# SERVICE: daemon/squid
# NAME: Squid
# DESCRIPTION: Caching web proxy server
# WWW: http://www.squid-cache.org/

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset respawn
		iset exec daemon = "@/usr/sbin/squid@ -N"
	idone
}
