#!/sbin/runiscript

setup()
{
    iregister virtual
	iregister -s udev/udevd daemon
	iregister -s udev/mountdev service
	iregister -s udev/set_hotplug service
	iregister -s udev/filldev service

	# Set the deps
    iset need = "udev/filldev udev/udevd udev/set_hotplug"
	iset -s udev/udevd need = "udev/mountdev initial/mountvirtfs"
	iset -s udev/mountdev need = initial/mountvirtfs
	iset -s udev/set_hotplug need = "udev/udevd initial/mountvirtfs"
	iset -s udev/filldev need = "udev/udevd"

	# Set criticals
	iset -s udev/udevd critical
	iset -s udev/mountdev critical
	iset -s udev/set_hotplug critical
	iset -s udev/filldev critical
	
	# Set up udevd daemon
	iset -s udev/udevd respawn
	iset -s udev/udevd pid_of = "udevd"
	iset -s udev/udevd forks;
	iset -s udev/udevd exec daemon = "@/sbin/udevd@ --daemon"
	
	
	# Add execution in this local script
	iexec -s udev/mountdev start = mountdev_start
	iexec -s udev/set_hotplug start = set_hotplug_start
	iexec -s udev/set_hotplug stop = hotplug_stop
	iexec -s udev/filldev start = fill_udev_start
#ifd gentoo
	iexec -s udev/filldev stop = fill_udev_stop
#endd

	# Tell initng this service is done parsing.
    idone
	idone -s udev/udevd
	idone -s udev/mountdev
	idone -s udev/set_hotplug
	idone -s udev/filldev
}

mountdev_start()
{
		error() {
			echo "${*}" >&2
			exit 1
		}

		[ -e /proc/filesystems ] || error "udev requires a mounted procfs, not started."
		@grep@ -q '[[:space:]]tmpfs$' /proc/filesystems || error "udev requires tmpfs support, not started."
		[ -d /sys/block ] || error "udev requires a mounted sysfs, not started."

		# THIS service doesn't need this: (I'll remove it 12.1.) (deac)
		# [ -e /proc/sys/kernel/hotplug ] || error "udev requires hotplug support, not started."

		# mount a tmpfs over /dev, if somebody did not already do it
		@grep@ -Eq "^[^[:space:]]+[[:space:]]+/dev[[:space:]]+tmpfs[[:space:]]+" /proc/mounts && exit 0

#ifd debian ubuntu
		# /dev/.static/dev is used by MAKEDEV to access the real /dev directory.
		# /etc/udev is recycled as a temporary mount point because it's the only
		# directory which is guaranteed to be available.
		@mount@ -n --bind /dev /etc/udev
#endd
		if ! @mount@ -n -o size=$tmpfs_size,mode=0755 -t tmpfs udev /dev
		then
			@umount@ -n /etc/udev
			error "udev in /dev his own filesystem (tmpfs), not started."
		fi
#ifd debian ubuntu
		@mkdir@ -p /dev/.static/dev
		@chmod@ 700 /dev/.static/
		@mount@ -n --move /etc/udev /dev/.static/dev
#endd

		# Make some default static onces, so we are sure they will exist.
		@mknod@ -m0666 /dev/null c 1 3
		@mknod@ -m0666 /dev/zero c 1 5
		@mknod@ /dev/console c 5 1

		# Send SIGHUP to initng, will reopen /dev/initctl and /dev/initng.
		# we can't assume that initng has pid 1, e.g. when booting from initrd
		@kill@ -SIGHUP `pidof initng`
		
		# Why? it's already mounted! (i'll remove it at 12.1., if no reason (deac))
		# [ -d /proc/1 ] || @mount@ -n /proc
		exit 0
}

set_hotplug_start()
{
		# Make sure hotplug is not missing. The reason, because initng starts sulogin.
		[ -e /proc/sys/kernel/hotplug ] || echo "/proc/sys/kernel/hotplug is missing!"

		unamer=$(uname -r | @/bin/sed@ -e '{ s/^[0-9][0-9]*\.[0-9][0-9]*\.//; s/[\.-].*// }')
		if [ "${unamer}" -ge 15 ]
		then
			# #425: Kernels >= 2.6.15 can directly read udev events via a netlink
			# socket. So there is no need anymore to run udevsend for every event.
			echo ""
		else
			# Setup hotplugging (if possible), if it can't it exits with error.
			echo "@/sbin/udevsend:/sbin/hotplug:/sbin/udev@"
		fi >/proc/sys/kernel/hotplug
}

set_hotplug_stop()
{
		# every new hotplug-event can do something wrong.
		echo "" >/proc/sys/kernel/hotplug
}

fill_udev_start()
{
#ifd gentoo
		source /etc/conf.d/rc
		if [ "${RC_DEVICE_TARBALL}" = "yes" -a -e /lib/udev-state/devices.tar.bz2 ]
		then
			cd /dev
			@/bin/tar@ -xjf /lib/udev-state/devices.tar.bz2
		fi
#elsed
# debian
		if [ -e /etc/udev/links.conf ]
		then
			@grep@ '^[^#]' /etc/udev/links.conf | \
			while read type name arg1
			do
				[ "${type}" -a "${name}" -a ! -e "/dev/${name}" -a ! -L "/dev/${name}" ] || continue
				case "${type}" in
					L) @/bin/ln@ -snf ${arg1} /dev/${name} & ;;
					D) @/bin/mkdir@ -p /dev/${name} ;;
					M) @/bin/mknod@ --mode=600 /dev/${name} ${arg1} &;;
					*) echo "/etc/udev/links.conf: unparseable line (${type} ${name} ${arg1})" ;;
				esac
			done
		fi
#endd
		# A complete dir to copy
		if [ -d /lib/udev/devices ]
		then
			# Copy over default device tree
			{
				cd /lib/udev/devices &&
				#@find@ -print0 | @cpio@ --quiet -0pmdu /dev
				tar c . | tar x --directory=/dev/
			} &
		fi
#ifd fedora
		#Don't know why, but this seems to be needed on Fedora...
		@/bin/ln@ -snf /proc/self/fd /dev/fd
#endd

#ifd gentoo
		# No-one else creates these; we need to do it manually
		@/bin/ln@ -snf /proc/self/fd /dev/fd
		@/bin/ln@ -snf fd/0 /dev/stdin
		@/bin/ln@ -snf fd/1 /dev/stdout
		@/bin/ln@ -snf fd/2 /dev/stderr
		@/bin/ln@ -snf /proc/kcore /dev/core
		@/bin/ln@ -snf /proc/asound/oss/sndstat /dev/sndstat
		exec @/sbin/udevstart@
#elsed
		if [ ! -e /etc/udev/links.conf -a ! -d /lib/udev/devices ]
		then
			# Some manually, youst to be sure.
			@/bin/ln@ -snf /proc/self/fd /dev/fd &
			@/bin/ln@ -snf fd/0 /dev/stdin &
			@/bin/ln@ -snf fd/1 /dev/stdout &
			@/bin/ln@ -snf fd/2 /dev/stderr &
			@/bin/ln@ -snf /proc/kcore /dev/core &
			@/bin/ln@ -snf /proc/asound/oss/sndstat /dev/sndstat &
		fi

		# which system provides udevsynthesize? gentoo does not.
		# and which provides udevplug? gentoo does not, too.
		# udevtrigger is available since udev 088
		# udevsettle is available since udev 090

		if [ -x "@/sbin/udevtrigger@" -a -x "@/sbin/udevsettle@" ]
		then
    			# if this directories are not present /dev will not be updated by udev
    			@/bin/mkdir@ -p /dev/.udev/db/ /dev/.udev/queue/

			# send hotplug events
			@/sbin/udevtrigger@

			# wait for the udevd childs to finish
			@/sbin/udevsettle@ --timeout=300
		elif [ -x "@/sbin/udevsynthesize@" ]
		then
			# run syntesizers that will make hotplug events for every
			# devices that is currently in the computer, that will
			# create all dev files.

			udevd_timeout=300
			echo "Running @/sbin/udevsynthesize@ to populate /dev ..."
			@/bin/mkdir@ -p /dev/.udev/db /dev/.udev/queue /dev/.udevdb

			@/sbin/udevsynthesize@

			# wait for the udevd childs to finish
			echo "Waiting for /dev to be fully populated ..."
			while [ -d /dev/.udev/queue/ -a ${udevd_timeout} -ne 0 ]
			do
				sleep .2
				udevd_timeout=$((${udevd_timeout}-1))
			done
		elif [ -x "@/sbin/udevplug@" ]
		then
			@/sbin/udevplug@
		elif [ -x "@/sbin/udevstart@" ]
		then
			udevd_timeout=60
			@/sbin/udevstart@

			# wait for the udevd childs to finish
			echo "Waiting for /dev to be fully populated ..."
			while [ -d /dev/.udev/queue/ -a ${udevd_timeout} -ne 0 ]
			do
				sleep .2
				udevd_timeout=$((${udevd_timeout}-1))
			done
		fi
#endd
		chmod 0666 /dev/null
}

#ifd gentoo
fill_udev_stop()
{
		source /etc/conf.d/rc
		if [ "${RC_DEVICE_TARBALL}" = "yes" ]
		then
			cd /dev
			@/bin/tar@ -cjf /lib/udev-state/devices.tar.bz2
		fi
		exit 0
}
#endd
