# NAME: ProFTPD
# DESCRIPTION: Secure and configurable FTP server.
# WWW: http://www.proftpd.org/

setup()
{
	ireg daemon daemon/proftpd && {
		iset need = system/bootmisc virtual/net
		iset pid_file = "/var/run/proftpd.pid"
		iset daemon_stops_badly
		iset forks
		iset exec daemon = "@/usr/sbin/proftpd@"
	}
}
