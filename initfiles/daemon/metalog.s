# NAME: Metalog
# DESCRIPTION: System logger
# WWW: http://metalog.sourceforge.net

setup()
{
	iregister daemon

	iset provide = "virtual/syslog"
#ifd debian
	iset need = "system/bootmisc daemon/syslogd/prepare"
#elsed
	iset need = "system/bootmisc"
#endd
	iset pid_file = "/var/run/metalog.pid"
	iset forks
	iset daemon_stops_badly

	iexec daemon = "@/usr/sbin/metalog@ -B -p /var/run/metalog.pid"

	idone
}

