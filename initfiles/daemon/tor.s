# NAME: Tor
# DESCRIPTION: Anonymising proxy network
# WWW: http://tor.eff.org

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset suid = debian-tor
	iset sgid = debian-tor
	iset pid_of = tor
	iset respawn

	iexec daemon = "@/usr/sbin/tor@"

	idone
}

