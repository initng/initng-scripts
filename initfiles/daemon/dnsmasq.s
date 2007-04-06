# NAME: dnsmasq
# DESCRIPTION: Forwarding DNS server
# WWW: http://www.thekelleys.org.uk/dnsmasq/

setup()
{
	ireg daemon daemon/dnsmasq
	iset need = system/initial virtual/net
	iset stdall = /dev/null
	iset pid_file = "/var/run/dnsmasq.pid"
	iset forks
	iset respawn
	iset exec daemon = "@/usr/sbin/dnsmasq@"
	idone
}
