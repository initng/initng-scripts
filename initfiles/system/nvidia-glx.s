# NAME:
# DESCRIPTION:
# WWW:

source /etc/sysconfig/nvidia-config-display

setup()
{
	iregister -s "service/nvidia-glx/dev" service
	iexec     -s "service/nvidia-glx/dev" start = dev_start
	idone     -s "service/nvidia-glx/dev"

	iregister -s "service/nvidia-glx" service
	iset      -s "service/nvidia-glx" need = "system/bootmisc"
	iset      -s "service/nvidia-glx" use = "service/nvidia-glx/dev"
	iexec     -s "service/nvidia-glx" start
	iexec     -s "service/nvidia-glx" stop
	idone     -s "service/nvidia-glx"
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
