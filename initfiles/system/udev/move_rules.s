# SERVICE: system/udev/move_rules
# NAME: udev
# DESCRIPTION: The Linux Userspace Device filesystem
# WWW: http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html

setup() {
	iregister service
		iset need = system/udev/udevd system/mountroot/rootrw
		iexec start
	idone
}

start() {
	for file in /dev/.udev/tmp-rules--*; do
		dest=${file##*tmp-rules--}
		[ "$dest" = '*' ] && break
		{
			@/bin/cp@ $file /etc/udev/rules.d/$dest
			rm -f $file
		} &
	done
	wait
}
