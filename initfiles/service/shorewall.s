# NAME: Shorewall
# DESCRIPTION: High-level tool for configuring Netfilter.
# WWW: http://www.shorewall.net/

setup()
{
	ireg service service/shorewall && {
		iset need = system/bootmisc virtual/net
		iset use = daemon/ulogd
		iset provide = virtual/firewall
		iset exec start = "@/sbin/shorewall@ -q start"
		iset exec stop = "@/sbin/shorewall@ stop"
	}
}
