# SERVICE: daemon/dhcdbd
# NAME: dhcdbd
# DESCRIPTION: D-Bus interface to dhclient.
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc daemon/dbus
		iset exec daemon = "@/usr/sbin/dhcdbd@ --system --no-daemon"
	idone
}
