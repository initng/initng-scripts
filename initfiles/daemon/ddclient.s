# SERVICE: daemon/ddclient
# NAME: ddclient
# DESCRIPTION: Update client for DynDNS.com's dynamic IP service (and others)
# WWW: http://ddclient.sourceforge.net/

PIDFILE="/var/run/ddclient/ddclient.pid"

setup()
{
	iregister daemon
		iset suid = ddclient
		iset sgid = ddclient
		iset need = virtual/net system/bootmisc
		iset pid_file = "$PIDFILE"
		iset forks
		iset respawn
		iset exec daemon = "@/usr/sbin/ddclient@ -pid $PIDFILE"
	idone
}
