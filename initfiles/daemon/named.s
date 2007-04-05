# NAME:
# DESCRIPTION:
# WWW:

CPU="1"
KEY="/etc/bind/rndc.key"
PIDFILE="/var/run/named/named.pid"
source /etc/conf.d/named

setup()
{
	ireg daemon daemon/named
	iset need = system/bootmisc virtual/net
	iset suid = named
	iset pid_file = "${PIDFILE}"
	iset exec daemon = "@named@ -n ${CPU} ${OPTIONS} -u named"
	idone
}
