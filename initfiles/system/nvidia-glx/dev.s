# SERVICE: system/nvidia-glx/dev
# NAME:
# DESCRIPTION:
# WWW:

[ -f /etc/sysconfig/nvidia-config-display ] &&
	. /etc/sysconfig/nvidia-config-display

setup()
{
	iregister service
		iexec start
	idone
}

start()
{
	[ -d /etc/udev/devices ] &&
		cp -a /etc/udev/devices/nvidia* /dev
}
