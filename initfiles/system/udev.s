# NAME: udev
# DESCRIPTION: The Linux Userspace Device filesystem
# WWW: http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html

setup()
{
	iregister -s "system/udev" virtual
	iregister -s "system/udev/udevd" daemon
	iregister -s "system/udev/move_rules" service
	iregister -s "system/udev/retry_failed" service
	iregister -s "system/udev/mountdev" service
	iregister -s "system/udev/filldev" service

	iset -s "system/udev" critical
	iset -s "system/udev" need = "system/udev/filldev system/udev/udevd"
	iset -s "system/udev" also_start = "system/udev/move_rules system/udev/retry_failed"
	iset -s "system/udev/udevd" critical
	iset -s "system/udev/udevd" need = "system/udev/mountdev system/initial/mountvirtfs"
	iset -s "system/udev/udevd" respawn
	iset -s "system/udev/move_rules" need = "system/udev/udevd system/mountroot/rootrw"
	iset -s "system/udev/retry_failed" need = "system/udev/udevd system/mountfs/essential system/udev/move_rules"
	iset -s "system/udev/mountdev" critical
	iset -s "system/udev/mountdev" need = "system/initial/mountvirtfs"
	iset -s "system/udev/filldev" critical
	iset -s "system/udev/filldev" need = "system/udev/udevd"

	iexec -s "system/udev/udevd" daemon = "@/sbin/udevd@"
	iexec -s "system/udev/move_rules" start = move_rules_start
	iexec -s "system/udev/retry_failed" start = retry_failed_start
	iexec -s "system/udev/mountdev" start = mountdev_start
	iexec -s "system/udev/filldev" start = filldev_start
#ifd gentoo enlisy
	iexec -s "system/udev/filldev" stop = filldev_stop
#endd

	idone -s "system/udev"
	idone -s "system/udev/udevd"
	idone -s "system/udev/move_rules"
	idone -s "system/udev/retry_failed"
	idone -s "system/udev/mountdev"
	idone -s "system/udev/filldev"
}

move_rules_start()
{
		for file in /dev/.udev/tmp-rules--*
		do
			dest=${file##*tmp-rules--}
			[ "$dest" = '*' ] && break
			{
				@/bin/cp@ $file /etc/udev/rules.d/$dest
				rm -f $file
			} &
		done
		wait
}

retry_failed_start()
{
		[ -x "@/sbin/udevtrigger@" ] || exit 0

		# Check if it supports the --retry-failed argument before
		# calling.
		@/sbin/udevtrigger@ --help 2>&1 | grep -q -- --retry-failed &&
		@/sbin/udevtrigger@ --retry-failed
		exit 0
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
		@/bin/killall@ -HUP initng

		exit 0
}

filldev_start()
{
#ifd gentoo enlisy
		source /etc/conf.d/rc
		if [ "${RC_DEVICE_TARBALL}" = "yes" -a -e /lib/udev-state/devices.tar.bz2 ]
		then
			cd /dev
			@/bin/tar@ -xjf /lib/udev-state/devices.tar.bz2
		fi
#elsed debian ubuntu
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
#elsed suse
		if [ -d /etc/sysconfig/hardware ]
		then
			CFGS=`@/bin/ls@ /etc/sysconfig/hardware | @/bin/grep@ ^hwcfg-static- | @/bin/sed@ s:^hwcfg-static-::`
			for cfg in ${CFGS}
			do
				[ -f $cfg ] && /sbin/hwup static-${cfg} ${cfg} -o auto > /dev/null 2>&1
			done
		fi
#endd

		# Copy contents of /etc/udev/devices and /lib/udev/devices
	        for devdir in /etc/udev/devices /lib/udev/devices; do
        	        if [ -d "$devdir" ]
			then
			{
               			cd $devdir &&
				tar c . | tar x --directory=/dev/
			} &
			fi
		done

#ifd fedora
		#Don't know why, but this seems to be needed on Fedora...
		@/bin/ln@ -snf /proc/self/fd /dev/fd
#endd

#ifd gentoo enlisy
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
			# Some manually, just to be sure.
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

#ifd debian
		if [ -e /sbin/MAKEDEV ]
		then
			ln -sf /sbin/MAKEDEV /dev/MAKEDEV
		else
			ln -sf /sbin/true /dev/MAKEDEV
		fi
#endd
}
#ifd gentoo enlisy

filldev_stop()
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