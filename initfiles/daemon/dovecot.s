# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/dovecot && {
		iset need = system/bootmisc virtual/net
		iset pid_file = "/var/run/dovecot/master.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/dovecot@"
	}
}
