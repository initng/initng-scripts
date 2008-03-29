# SERVICE: daemon/syslog-ng
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset provide = virtual/syslog
		iset need = system/bootmisc
#ifd debian
		iset need = daemon/syslogd/prepare
#endd
		iset exec daemon = "@/sbin/syslog-ng@ --foreground"
	idone
}
