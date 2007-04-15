# NAME:
# DESCRIPTION:
# WWW:

#ifd gentoo
. /etc/conf.d/lircd
#elsed
LIRCD_OPTS="-d /dev/lirc/0"
#endd

setup()
{
	ireg daemon daemon/lirc/lircd && {
		iset need = system/bootmisc system/modules
		iset use = system/discover system/coldplug system/modules
		iset pid_file = "/var/run/lircd.pid"
		iset forks
		iexec daemon
	}
}

daemon()
{
	exec @/usr/sbin/lircd@ ${LIRCD_OPTS} -P /var/run/lircd.pid
}
