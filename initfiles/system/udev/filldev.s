# SERVICE: system/udev/filldev
# NAME: udev
# DESCRIPTION: The Linux Userspace Device filesystem
# WWW: http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html

setup()
{
	iregister service
		iset critical
		iset need = system/udev/udevd
		iexec start
#ifd gentoo enlisy
		iexec stop
#endd
	idone
}

start()
{
#ifd gentoo enlisy
	. /etc/conf.d/rc
	if [ "${RC_DEVICE_TARBALL}" = "yes" -a -e /lib/udev-state/devices.tar.bz2 ]; then
		cd /dev
		@/bin/tar@ -xjf /lib/udev-state/devices.tar.bz2
	fi
#elsed debian ubuntu
	if [ -e /etc/udev/links.conf ]; then
		@grep@ '^[^#]' /etc/udev/links.conf | \
		while read type name arg1; do
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
	if [ -d /etc/sysconfig/hardware ]; then
		CFGS=`@/bin/ls@ /etc/sysconfig/hardware | @/bin/grep@ ^hwcfg-static- | @/bin/sed@ s:^hwcfg-static-::`
		for cfg in ${CFGS}; do
			[ -f $cfg ] && /sbin/hwup static-${cfg} ${cfg} -o auto > /dev/null 2>&1
		done
	fi
#endd

	# Copy contents of /etc/udev/devices and /lib/udev/devices
        for devdir in /etc/udev/devices /lib/udev/devices; do
       	        if [ -d "$devdir" ]; then
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
	if [ ! -e /etc/udev/links.conf -a ! -d /lib/udev/devices ]; then
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

	if [ -x "@/sbin/udevtrigger@" -a -x "@/sbin/udevsettle@" ]; then
		# if this directories are not present /dev will not be updated by udev
		@/bin/mkdir@ -p /dev/.udev/db/ /dev/.udev/queue/

		# send hotplug events
		@/sbin/udevtrigger@

		# wait for the udevd childs to finish
		@/sbin/udevsettle@ --timeout=300
	elif [ -x "@/sbin/udevsynthesize@" ]; then
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
	elif [ -x "@/sbin/udevplug@" ]; then
		@/sbin/udevplug@
	elif [ -x "@/sbin/udevstart@" ]; then
		udevd_timeout=60
		@/sbin/udevstart@

		# wait for the udevd childs to finish
		echo "Waiting for /dev to be fully populated ..."
		while [ -d /dev/.udev/queue/ -a ${udevd_timeout} -ne 0 ]; do
			sleep .2
			udevd_timeout=$((${udevd_timeout}-1))
		done
	fi
#endd
	chmod 0666 /dev/null

#ifd debian
	if [ -e /sbin/MAKEDEV ]; then
		ln -sf /sbin/MAKEDEV /dev/MAKEDEV
	else
		ln -sf /sbin/true /dev/MAKEDEV
	fi
#endd
}
#ifd gentoo enlisy

stop()
{
	. /etc/conf.d/rc
	if [ "${RC_DEVICE_TARBALL}" = "yes" ]; then
		cd /dev
		@/bin/tar@ -cjf /lib/udev-state/devices.tar.bz2
	fi
	exit 0
}
#endd