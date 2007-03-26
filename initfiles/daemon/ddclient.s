# NAME: ddclient
# DESCRIPTION: Update client for DynDNS.com's dynamic IP service (and others)
# WWW: http://ddclient.sourceforge.net/

setup()
{
	iregister daemon

	iset suid = ddclient
	iset sgid = ddclient
	iset need = "virtual/net system/bootmisc"
	iset pid_file = "/var/run/ddclient/ddclient.pid"
	iset forks
	iset respawn

	iset exec daemon = "@/usr/sbin/ddclient@"

	idone
}

