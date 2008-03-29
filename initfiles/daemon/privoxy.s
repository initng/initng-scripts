# SERVICE: daemon/privoxy
# NAME: Privoxy
# DESCRIPTION: Anonymising proxy server
# WWW: http://www.privoxy.org

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset respawn
		iset daemon_stops_badly
		iset exec daemon = "@/usr/sbin/privoxy@ --no-daemon --user privoxy.privoxy /etc/privoxy/config"
	idone
}
