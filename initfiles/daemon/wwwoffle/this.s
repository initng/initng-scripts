# SERVICE: daemon/wwwoffle
# NAME: WWWOFFLE
# DESCRIPTION: Simple proxy with some nice features, very useful for dial-up
#              internet links.
# WWW:

CONFIG="/etc/wwwoffle/wwwoffle.conf"

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset stdall = "/var/log/wwwoffle.log"
		iset respawn
		iset exec daemon = "@wwwoffled@ -c ${CONFIG} -d"
	idone
}
