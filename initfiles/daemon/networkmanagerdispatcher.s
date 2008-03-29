# SERVICE: daemon/networkmanagerdispatcher
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc daemon/dbus daemon/networkmanager
		iset exec daemon = "@/usr/sbin/NetworkManagerDispatcher@ --no-daemon"
	idone
}
