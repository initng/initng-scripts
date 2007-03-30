# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="daemon/syslog-ng"
	iregister daemon
	iset provide = "virtual/syslog"
#ifd debian
	iset need = "system/bootmisc daemon/syslogd/prepare"
#elsed
	iset need = "system/bootmisc"
#endd
	iset pid_file = "/var/run/syslog-ng.pid"
	iset forks
	iset exec daemon = "@/sbin/syslog-ng@ -p /var/run/syslog-ng.pid"
	idone
}
