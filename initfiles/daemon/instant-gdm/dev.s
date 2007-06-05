# SERVICE: daemon/instant-gdm/dev
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/bootmisc
		iexec start
	idone
}

start()
{
	[ -e /sys/class/input/mice/dev ] || exit 0
	@mkdir@ -p /dev/input
	@mknod@ /dev/input/mice c 13 63 >/dev/null 2>&1
}
