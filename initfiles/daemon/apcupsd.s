# SERVICE: daemon/apcupsd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset pid_file = "/var/run/apcupsd.pid"
		iset forks
		iexec daemon
	idone
}

daemon()
{
	rm -f /etc/apcupsd/powerfail /etc/nologin
	exec @/usr/sbin/apcupsd@ -f /etc/apcupsd/apcupsd.conf
}
