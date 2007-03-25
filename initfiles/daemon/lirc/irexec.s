# NAME:
# DESCRIPTION:
# WWW:

user="nobody"
source /etc/conf.d/irexec

setup()
{
	iregister daemon

	iset suid = ${user}
	iset need = "daemon/lirc/lircd system/bootmisc"
	iset respawn
	iset stdout = /dev/null

	iexec daemon = "@irexec@"

	idone
}

