# NAME: BitlBee
# DESCRIPTION: IM (AIM/MSN/Jabber/Yahoo IM) to IRC gateway (daemon mode)
# WWW: http://www.bitlbee.org

setup()
{
	ireg daemon daemon/bitlbee-daemon && {
		iset suid = nobody
		iset conflict = daemon/bitlbee-bitlbeed
		iset need = system/bootmisc virtual/net
		iset respawn
		iset forks
		iset pid_of = bitlbee
		iset exec daemon = "@/usr/sbin/bitlbee@"
	}
}
