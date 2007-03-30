# NAME:
# DESCRIPTION:
# WWW:

source /etc/sysconfig/nvidia-config-display

setup()
{
	export SERVICE="system/nvidia-glx/dev"
	iregister service
	iexec start = dev_start
	idone

	export SERVICE="system/nvidia-glx"
	iregister service
	iset need = "system/bootmisc"
	iset use = "service/nvidia-glx/dev"
	iexec start
	iexec stop
	idone
}

dev_start()
{
	[ -d /etc/udev/devices ] &&
		cp -a /etc/udev/devices/nvidia* /dev
}

start()
{
	echo "Checking for nvidia kernel module..."
	if [ -e "/lib/modules/`uname -r`/extra/nvidia/nvidia.ko" ]
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

stop()
{
	@/usr/sbin/nvidia-config-display@ disable
	retval=${?}
	[ ${retval} = 0 ] && @rm@ -f /var/lock/subsys/nvidia-glx
	exit ${retval}
}
