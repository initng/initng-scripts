# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net/lo system/modules/blkbk system/modules/blktap system/modules/netbk system/modules/netloop"
	iset use = "system/mountfs"
	iset pid_file = "/var/run/xend/xend.pid"

	iset exec daemon = xend_daemon
	iset exec kill = "@/usr/sbin/xend@ stop"

	idone
}

xend_daemon()
{
		if ! grep -q "control_d" /proc/xen/capabilities
		then
			@/usr/sbin/xend@ start
		else
			exit 1
		fi
}
