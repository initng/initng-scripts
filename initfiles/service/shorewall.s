# NAME: Shorewall
# DESCRIPTION: High-level tool for configuring Netfilter.
# WWW: http://www.shorewall.net/

setup()
{
	iregister service

	iset need = "system/bootmisc virtual/net"
	iset use = "daemon/ulogd"
	iset provide = "virtual/firewall"

	iexec start = "@/sbin/shorewall@ -q start"
	iexec stop = "@/sbin/shorewall@ stop"

	idone
}

