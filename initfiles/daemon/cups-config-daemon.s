# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/cupsd daemon/dbus"

	iexec daemon = "@/usr/bin/cups-config-daemon@ --daemon"

	idone
}

