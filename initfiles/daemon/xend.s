# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/xend
	iset need = system/bootmisc virtual/net/lo \
	            system/modules/{blkbk,blktap,netbk,netloop}
	iset use = system/mountfs
	iset pid_file = "/var/run/xend/xend.pid"
	iexec daemon
	iset exec kill = "@/usr/sbin/xend@ stop"
	idone
}

xend_daemon()
{
	grep -q "control_d" /proc/xen/capabilities && exit 1
	exec @/usr/sbin/xend@ start
}
