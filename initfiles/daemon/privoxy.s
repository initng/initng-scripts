# SERVICE: daemon/privoxy
# NAME: Privoxy
# DESCRIPTION: Anonymising proxy server
# WWW: http://www.privoxy.org

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset pid_file = "/var/run/privoxy.pid"
		iset forks
		iset respawn
		iset daemon_stops_badly
		iset exec daemon = "@/usr/sbin/privoxy@ --pidfile /var/run/privoxy.pid --user privoxy.privoxy /etc/privoxy/config"
	idone
}
