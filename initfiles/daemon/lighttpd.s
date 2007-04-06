# NAME: lighttpd
# DESCRIPTION: Very high performance web server.
# WWW: http://www.lighttpd.net/

setup()
{
	ireg daemon daemon/lighttpd
	iset need = system/bootmisc virtual/net
	iset use = system/modules system/coldplug
#ifd gentoo
	iset exec daemon = "@/usr/sbin/lighttpd@ -D -f /etc/lighttpd.conf"
#elsed
	iset exec daemon = "@/usr/sbin/lighttpd@ -D -f /etc/lighttpd/lighttpd.conf"
#endd
	idone
}
