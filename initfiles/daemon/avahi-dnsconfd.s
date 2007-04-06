# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/avahi-dnsconfd
	iset need = system/bootmisc daemon/dbus daemon/avahi-daemon virtual/net
	iset exec daemon = "@/usr/sbin/avahi-dnsconfd@"
	idone
}
