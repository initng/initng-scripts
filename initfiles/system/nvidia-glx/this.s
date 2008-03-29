# SERVICE: system/nvidia-glx
# NAME:
# DESCRIPTION:
# WWW:

[ -f /etc/sysconfig/nvidia-config-display ] &&
	. /etc/sysconfig/nvidia-config-display

setup() {
	iregister service
		iset need = system/bootmisc
		iset use = service/nvidia-glx/dev
		iexec start
		iexec stop
	idone
}

start() {
	echo "Checking for nvidia kernel module..."
	if [ -e "/lib/modules/`uname -r`/extra/nvidia/nvidia.ko" ]
#ifd fedora
	|| [ -e "/lib/modules/`uname -r`/extra/nvidia-legacy/nvidia.ko" ]
#endd
	then
		echo "Nvidia kernel module found."
		@/usr/sbin/nvidia-config-display@ enable
	else
		echo "Nvidia kernel module not found."
		@/usr/sbin/nvidia-config-display@ disable
	fi
	retval=${?}

	[ ${retval} = 0 ] && @touch@ /var/lock/subsys/nvidia-glx
	exit ${retval}
}

stop() {
	@/usr/sbin/nvidia-config-display@ disable
	retval=${?}
	[ ${retval} = 0 ] && @rm@ -f /var/lock/subsys/nvidia-glx
	exit ${retval}
}
