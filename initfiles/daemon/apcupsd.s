# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset pid_file = "/var/run/apcupsd.pid"
	iset forks

	iset exec daemon = apcupsd_daemon

	idone
}

apcupsd_daemon()
{
       		rm -f /etc/apcupsd/powerfail
		rm -f /etc/nologin
		exec /usr/sbin/apcupsd -f /etc/apcupsd/apcupsd.conf
	}
}
