# SERVICE: daemon/syslog-ng
# NAME: syslog-ng
# DESCRIPTION: Flexible syslog replacement.
# WWW: http://www.balabit.com/network-security/syslog-ng/

setup() {
	iregister daemon
		iset provide = virtual/syslog
		iset need = system/bootmisc
#ifd debian
		iset need = daemon/syslogd/prepare
		iset exec daemon = "@/usr/sbin/syslog-ng@ --foreground"
#elsed
		iset exec daemon = "@/sbin/syslog-ng@ --foreground"
#endd
	idone
}
