# SERVICE: daemon/xend
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc virtual/net/lo \
		            system/modules/blkbk system/modules/blktap \
			    system/modules/netbk system/modules/netloop
		iset use = system/mountfs
		iset pid_file = "/var/run/xend/xend.pid"
		iexec daemon
		iset exec kill = "@/usr/sbin/xend@ stop"
	idone
}

daemon()
{
	grep -q "control_d" /proc/xen/capabilities && exit 1
	exec @/usr/sbin/xend@ start
}
