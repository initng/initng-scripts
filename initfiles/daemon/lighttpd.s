# SERVICE: daemon/lighttpd
# NAME: lighttpd
# DESCRIPTION: Very high performance web server.
# WWW: http://www.lighttpd.net/

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset use = system/modules system/coldplug
		iset exec daemon = "@/usr/sbin/lighttpd@ -D -f /etc/lighttpd/lighttpd.conf"
	idone
}
