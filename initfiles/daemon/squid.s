# NAME: Squid
# DESCRIPTION: Caching web proxy server
# WWW: http://www.squid-cache.org/

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset pid_file = "/var/run/squid.pid"
	iset respawn
	iset forks

	iexec daemon = "@/usr/sbin/squid@"
	iexec kill = "@/usr/sbin/squid@ -k shutdown"

	idone
}

