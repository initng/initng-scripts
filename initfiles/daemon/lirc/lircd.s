# NAME:
# DESCRIPTION:
# WWW:

#ifd gentoo
source /etc/conf.d/lircd
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc system/modules"
	iset use = "system/discover system/coldplug system/modules"
	iset pid_file = "/var/run/lircd.pid"
	iset forks

#ifd gentoo
	iset exec daemon = "@/usr/sbin/lircd@ ${LIRCD_OPTS} -P /var/run/lircd.pid"
#elsed
	iset exec daemon = "@/usr/sbin/lircd@ -d /dev/lirc/0 -P /var/run/lircd.pid"
#endd

	idone
}
