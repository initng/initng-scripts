# NAME: BitlBee
# DESCRIPTION: IM (AIM/MSN/Jabber/Yahoo IM) to IRC gateway (daemon mode)
# WWW: http://www.bitlbee.org

setup()
{
	iregister daemon

	iset suid = nobody
	iset sgid = nobody
	iset conflict = "daemon/bitlbee-bitlbeed"
	iset need = "system/bootmisc virtual/net"
	iset respawn
	iset forks
	iset pid_of = bitlbee

	iexec daemon = "/usr/sbin/bitlbee"

	idone
}

