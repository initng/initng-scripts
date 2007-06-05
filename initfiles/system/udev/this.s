# SERVICE: system/udev
# NAME: udev
# DESCRIPTION: The Linux Userspace Device filesystem
# WWW: http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html

setup()
{
	iregister virtual
		iset critical
		iset need = system/udev/filldev system/udev/udevd
		iset also_start = system/udev/move_rules \
		                  system/udev/retry_failed
	idone
}
