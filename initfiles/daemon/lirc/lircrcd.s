# NAME:
# DESCRIPTION:
# WWW:

user="nobody"
conf="/etc/lircrcd.conf"
[ -f /etc/conf.d/lircrcd ] && . /etc/conf.d/lircrcd

setup()
{
	ireg daemon daemon/lirc/lircrcd
	iset need = daemon/lirc/lircd
	iset respawn
	iset suid = "${user}"
	iset pid_of = lircrcd
	iexec daemon
	idone
}

daemon()
{
	[ -n "${socket}" ] && socket="--output=${socket}"
	[ -n "${permission}" ] && permission="--permission=${permission}"
	exec @lircrcd@ --output="${socet}" ${permission} "${conf}"
}
