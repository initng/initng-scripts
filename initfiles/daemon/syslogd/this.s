# SERVICE: daemon/syslogd
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset provide = virtual/syslog
		iset need = system/bootmisc
#ifd debian
		iset need = daemon/syslogd/prepare
#elsed
		iset use = daemon/syslogd/prepare
#endd
		iset exec daemon = "@/sbin/syslogd@ -n -m 0"
	idone
}
