# SERVICE: daemon/lirc/irexec
# NAME:
# DESCRIPTION:
# WWW:

user="nobody"
[ -f /etc/conf.d/irexec ] && . /etc/conf.d/irexec

setup() {
	iregister daemon
		iset suid = "${user}"
		iset need = daemon/lirc/lircd system/bootmisc
		iset respawn
		iset stdout = /dev/null
		iset exec daemon = "@irexec@"
	idone
}
