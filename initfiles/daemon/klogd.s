# SERVICE: daemon/klogd
# NAME:
# DESCRIPTION:
# WWW:

#ifd debian
[ -f /etc/default/klogd ] && . /etc/default/klogd
#endd

setup() {
	iregister daemon
		iset need = system/bootmisc daemon/syslogd
		iset stdall = /dev/null
		iset daemon_stops_badly
#ifd debian
		iset exec daemon = "@/usr/sbin/klogd@ /u -n ${KLOGD_OPTIONS}"
#elsed
		iset exec daemon = "@/usr/sbin/klogd@ -n -c 1"
#endd
	idone
}
