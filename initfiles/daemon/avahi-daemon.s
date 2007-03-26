# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/dbus virtual/net"
	iset daemon_stops_badly

	iset exec daemon = "@/usr/sbin/avahi-daemon@ -s"

	idone
}

