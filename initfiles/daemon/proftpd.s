# NAME: ProFTPD
# DESCRIPTION: Secure and configurable FTP server.
# WWW: http://www.proftpd.org/

setup()
{
	export SERVICE="daemon/proftpd"
	iregister daemon
	iset need = "system/bootmisc virtual/net"
	iset pid_file = "/var/run/proftpd.pid"
	iset daemon_stops_badly
	iset forks
	iset exec daemon = "@/usr/sbin/proftpd@"
	idone
}
