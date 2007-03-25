# NAME:
# DESCRIPTION:
# WWW:

CONFFILE="/etc/snmp/snmpd.conf"
PIDFILE="/var/run/snmpd.pid"
OPTIONS="-Lsd -a"
#ifd fedora mandriva
source /etc/snmp/snmpd.options
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset pid_file = "${PIDFILE}"
	iset forks

	iexec daemon = "@/usr/sbin/snmpd@ ${OPTIONS} -c ${CONFFILE} -p ${PIDFILE}"

	idone
}

