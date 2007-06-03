# SERVICE: daemon/dnsmasq
# NAME: dnsmasq
# DESCRIPTION: Forwarding DNS server
# WWW: http://www.thekelleys.org.uk/dnsmasq/

setup()
{
	iregister daemon
		iset need = system/initial virtual/net
		iset stdall = /dev/null
		iset respawn
		iset exec daemon = "@/usr/sbin/dnsmasq@ -k"
	idone
}
