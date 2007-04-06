# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/cups-config-daemon
	iset need = system/bootmisc daemon/cupsd daemon/dbus
	iset exec daemon = "@/usr/bin/cups-config-daemon@ --daemon"
	idone
}
