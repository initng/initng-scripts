# SERVICE: daemon/avahi-dnsconfd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc daemon/dbus daemon/avahi-daemon \
		            virtual/net
		iset exec daemon = "@/usr/sbin/avahi-dnsconfd@"
	idone
}
