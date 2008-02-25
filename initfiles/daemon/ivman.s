# SERVICE: daemon/ivman
# NAME: ivman
# DESCRIPTION: Automounter
# WWW: http://ivman.sf.net

setup()
{
	iregister daemon
		iset need = system/bootmisc daemon/dbus daemon/hald
		iset exec daemon = "@/usr/bin/ivman@ --nofork"
	idone
}
