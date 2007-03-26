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
	iregister service

	iset need = "system/initial system/mountfs/essential system/hostname virtual/net/lo"
	iset provide = "virtual/firewall"
	iset stdin = "${STATEFILE}"
	iset exec start = "@/sbin/iptables-restore@ -c"

	idone
}
