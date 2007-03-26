# NAME: BitlBee
# DESCRIPTION: IM (AIM/MSN/Jabber/Yahoo IM) to IRC gateway (bitlbeed mode)
# WWW: http://www.bitlbee.org

setup()
{
	iregister daemon

	iset suid = nobody
	iset sgid = nobody
	iset conflict = "daemon/bitlbee-daemon"
	iset need = "system/bootmisc virtual/net"
	iset respawn
	iset forks
	iset pid_of = bitlbeed

	iset exec daemon = "/usr/bin/bitlbeed /usr/sbin/bitlbee"

	idone
}

