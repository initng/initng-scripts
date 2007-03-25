# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/dbus daemon/avahi-daemon virtual/net"

	iexec daemon = "@/usr/sbin/avahi-dnsconfd@"

	idone
}

