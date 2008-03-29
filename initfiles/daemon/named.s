# SERVICE: daemon/named
# NAME:
# DESCRIPTION:
# WWW:

CPU="1"
KEY="/etc/bind/rndc.key"
PIDFILE="/var/run/named/named.pid"
[ -f /etc/conf.d/named ] && . /etc/conf.d/named

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset suid = named
		iset pid_file = "${PIDFILE}"
		iset exec daemon = "@named@ -n ${CPU} ${OPTIONS} -u named"
	idone
}
