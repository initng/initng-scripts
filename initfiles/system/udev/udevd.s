# SERVICE: system/udev/udevd
# NAME: udev
# DESCRIPTION: The Linux Userspace Device filesystem
# WWW: http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html

setup()
{
	iregister daemon
		iset critical
		iset need = system/udev/mountdev system/initial/mountvirtfs
		iset respawn
		iset exec daemon = "@/sbin/udevd@"
	idone
}
