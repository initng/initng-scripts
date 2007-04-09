# NAME:
# DESCRIPTION:
# WWW:

user="nobody"
[ -f /etc/conf.d/irexec ] && . /etc/conf.d/irexec

setup()
{
	ireg daemon daemon/lirc/irexec
	iset suid = "${user}"
	iset need = daemon/lirc/lircd system/bootmisc
	iset respawn
	iset stdout = /dev/null
	iset exec daemon = "@irexec@"
	idone
}
