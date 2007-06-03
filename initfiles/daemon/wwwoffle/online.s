# SERVICE: daemon/wwwoffle/online
# NAME: WWWOFFLE
# DESCRIPTION: Simple proxy with some nice features, very useful for dial-up
#              internet links.
# WWW:

CONFIG="/etc/wwwoffle/wwwoffle.conf"

setup()
{
	iregister service
		iset need = daemon/wwwoffle virtual/net
		iset last
		iset exec start = "@wwwoffle@ -online -c ${CONFIG}"
		iset exec stop = "@wwwoffle@ -offline -c ${CONFIG}"
	idone
}
