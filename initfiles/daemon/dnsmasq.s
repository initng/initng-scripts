# NAME: dnsmasq
# DESCRIPTION: Forwarding DNS server
# WWW: http://www.thekelleys.org.uk/dnsmasq/

setup()
{
	ireg daemon daemon/dnsmasq && {
		iset need = system/initial virtual/net
		iset stdall = /dev/null
		iset respawn
		iset exec daemon = "@/usr/sbin/dnsmasq@ -k"
	}
}
