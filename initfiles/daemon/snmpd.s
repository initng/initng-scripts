# NAME:
# DESCRIPTION:
# WWW:

CONFFILE="/etc/snmp/snmpd.conf"
PIDFILE="/var/run/snmpd.pid"
OPTIONS="-Lsd -a"
#ifd fedora mandriva
[ -f /etc/snmp/snmpd.options ] && . /etc/snmp/snmpd.options
#endd

setup()
{
	ireg daemon daemon/snmpd && {
		iset need = system/bootmisc virtual/net
		iset pid_file = "${PIDFILE}"
		iset forks
		iset exec daemon = "@/usr/sbin/snmpd@ ${OPTIONS} -c ${CONFFILE} -p ${PIDFILE}"
	}
}
