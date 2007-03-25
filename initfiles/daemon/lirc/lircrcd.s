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

	iexec daemon = lircrcd_daemon

	idone
}

lircrcd_daemon()
{
		[ "${socket}" ] && socket="--output=${socket}"
		[ "${permission}" ] && permission"--permission=${permission}"
		@lircrcd@ --output="${socket}" ${permission} "${conf}"
	}
}
