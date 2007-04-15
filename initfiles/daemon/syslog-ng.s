# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/syslog-ng && {
		iset provide = virtual/syslog
		iset need = system/bootmisc
#ifd debian
		iset need = daemon/syslogd/prepare
#endd
		iset pid_file = "/var/run/syslog-ng.pid"
		iset forks
		iset exec daemon = "@/sbin/syslog-ng@ -p /var/run/syslog-ng.pid"
	}
}
