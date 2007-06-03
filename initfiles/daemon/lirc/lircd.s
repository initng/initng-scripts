# SERVICE: daemon/lirc/lircd
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
	iregister daemon
		iset need = system/bootmisc system/modules
		iset use = system/discover system/coldplug system/modules
		iset pid_file = "/var/run/lircd.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/lircd@ ${LIRCD_OPTS} -P /var/run/lircd.pid"
	idone
}
