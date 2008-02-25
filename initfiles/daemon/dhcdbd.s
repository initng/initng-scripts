# SERVICE: daemon/dhcdbd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc daemon/dbus
		iset exec daemon = "@/sbin/dhcdbd@ --system --no-daemon"
	idone
}
