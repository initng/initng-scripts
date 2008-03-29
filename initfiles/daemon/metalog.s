# SERVICE: daemon/metalog
# NAME: Metalog
# DESCRIPTION: System logger
# WWW: http://metalog.sourceforge.net

setup() {
	iregister daemon
		iset provide = virtual/syslog
		iset need = system/bootmisc
#ifd debian
		iset need = daemon/syslogd/prepare
#endd
		iset respawn
		iset daemon_stops_badly
		iset exec daemon = "@/usr/sbin/metalog@"
	idone
}
