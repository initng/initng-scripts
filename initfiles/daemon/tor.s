# NAME: Tor
# DESCRIPTION: Anonymising proxy network
# WWW: http://tor.eff.org

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"

#ifd debian
	iset suid = debian-tor
	iset sgid = debian-tor
#endd

	iset pid_of = tor
	iset respawn

	iset exec daemon = "@/usr/sbin/tor@"

	idone
}
