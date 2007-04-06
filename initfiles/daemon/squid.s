# NAME: Squid
# DESCRIPTION: Caching web proxy server
# WWW: http://www.squid-cache.org/

setup()
{
	ireg daemon daemon/squid
	iset need = system/bootmisc virtual/net
	iset pid_file = "/var/run/squid.pid"
	iset respawn
	iset forks
	iset exec daemon = "@/usr/sbin/squid@"
	iset exec kill = "@/usr/sbin/squid@ -k shutdown"
	idone
}
