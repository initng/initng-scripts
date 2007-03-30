# NAME: WWWOFFLE
# DESCRIPTION: Simple proxy with some nice features, very useful for dial-up
#              internet links.

CONFIG="/etc/wwwoffle/wwwoffle.conf"

setup()
{
	export SERVICE="daemon/wwwoffle/online"
	iregister service
	iset need = "daemon/wwwoffle virtual/net"
	iset last
	iset exec start = "@wwwoffle@ -online -c ${CONFIG}"
	iset exec stop = "@wwwoffle@ -offline -c ${CONFIG}"
	idone

	export SERVICE="daemon/wwwoffle"
	iregister daemon
	iset need = "system/bootmisc"
	iset stdall = "/var/log/wwwoffle.log"
	iset respawn
	iset exec daemon = "@wwwoffled@ -c ${CONFIG} -d"
	idone
}
