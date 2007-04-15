# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/apcupsd && {
		iset need = system/bootmisc
		iset pid_file = "/var/run/apcupsd.pid"
		iset forks
		iexec daemon
	}
}

daemon()
{
	rm -f /etc/apcupsd/powerfail /etc/nologin
	exec @/usr/sbin/apcupsd@ -f /etc/apcupsd/apcupsd.conf
}
