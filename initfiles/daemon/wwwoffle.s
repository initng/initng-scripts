# NAME: WWWOFFLE
# DESCRIPTION: Simple proxy with some nice features, very useful for dial-up
#              internet links.

CONFIG="/etc/wwwoffle/wwwoffle.conf"

setup()
{
	ireg service daemon/wwwoffle/online && {
		iset need = daemon/wwwoffle virtual/net
		iset last
		iset exec start = "@wwwoffle@ -online -c ${CONFIG}"
		iset exec stop = "@wwwoffle@ -offline -c ${CONFIG}"
		return 0
	}

	ireg daemon daemon/wwwoffle && {
		iset need = system/bootmisc
		iset stdall = "/var/log/wwwoffle.log"
		iset respawn
		iset exec daemon = "@wwwoffled@ -c ${CONFIG} -d"
	}
}
