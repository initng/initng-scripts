# NAME:
# DESCRIPTION:
# WWW:

user="nobody"
conf="/etc/lircrcd.conf"
source /etc/conf.d/lircrcd

setup()
{
	iregister daemon

	iset need = "daemon/lirc/lircd"
	iset respawn
	iset suid = ${user}
	iset pid_of = lircrcd

	iset exec daemon = lircrcd_daemon

	idone
}

lircrcd_daemon()
{
	[ -n "${socket}" ] && socket="--output=${socket}"
	[ -n "${permission}" ] && permission="--permission=${permission}"
	@lircrcd@ --output="${socet}" ${permission} "${conf}"
}
