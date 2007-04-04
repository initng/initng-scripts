# NAME: iptables
# DESCRIPTION: Linux firewall, NAT and packet mangling tools
# WWW: http://www.iptables.org/

#ifd fedora mandriva
STATEFILE="/etc/sysconfig/iptables"
#elsed
STATEFILE="/var/lib/iptables/rules-save"
#endd

setup()
{
	export SERVICE="service/iptables"
	iregister service
	iset need = "system/initial system/mountfs/essential system/hostname virtual/net/lo"
	iset provide = "virtual/firewall"
	iexec start
	idone
}

start()
{
	[ -f "${STATEFILE}" ] || exit 0
	@/sbin/iptables-restore@ -c < "${STATEFILE}"
}
