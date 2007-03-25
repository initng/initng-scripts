# NAME: WWWOFFLE
# DESCRIPTION: Simple proxy with some nice features, very useful for dial-up
#              internet links.

CONFIG="/etc/wwwoffle/wwwoffle.conf"
CONFIG="/etc/wwwoffle/wwwoffle.conf"

setup()
{
	iregister -s "daemon/wwwoffle" daemon
	iregister -s "daemon/wwwoffle/online" service

	iset -s "daemon/wwwoffle" need = "system/bootmisc"
	iset -s "daemon/wwwoffle" stdall = /var/log/wwwoffle.log
	iset -s "daemon/wwwoffle" respawn
	iset -s "daemon/wwwoffle/online" need = "daemon/wwwoffle virtual/net"
	iset -s "daemon/wwwoffle/online" last

	iexec -s "daemon/wwwoffle" daemon = "@wwwoffled@ -c ${CONFIG} -d"
	iexec -s "daemon/wwwoffle/online" start = "@wwwoffle@ -online -c ${CONFIG}"
	iexec -s "daemon/wwwoffle/online" stop = "@wwwoffle@ -offline -c ${CONFIG}"

	idone -s "daemon/wwwoffle"
	idone -s "daemon/wwwoffle/online"
}

