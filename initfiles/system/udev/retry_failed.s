# SERVICE: system/udev/retry_failed
# NAME: udev
# DESCRIPTION: The Linux Userspace Device filesystem
# WWW: http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html

setup()
{
	iregister service
		iset need = system/udev/udevd system/udev/move_rules \
		            system/mountfs/essential
		iexec start
	idone
}

start()
{
	[ -x "@/sbin/udevtrigger@" ] || exit 0

	# Check if it supports the --retry-failed argument before
	# calling.
	@/sbin/udevtrigger@ --help 2>&1 | grep -q -- --retry-failed &&
		@/sbin/udevtrigger@ --retry-failed
	exit 0
}
