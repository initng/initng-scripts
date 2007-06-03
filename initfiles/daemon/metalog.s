# SERVICE: daemon/metalog
# NAME: Metalog
# DESCRIPTION: System logger
# WWW: http://metalog.sourceforge.net

setup()
{
	iregister daemon
		iset provide = virtual/syslog
		iset need = system/bootmisc
#ifd debian
		iset need = daemon/syslogd/prepare
#endd
		iset pid_file = "/var/run/metalog.pid"
		iset forks
		iset daemon_stops_badly
		iset exec daemon = "@/usr/sbin/metalog@ -B -p /var/run/metalog.pid"
	idone
}
