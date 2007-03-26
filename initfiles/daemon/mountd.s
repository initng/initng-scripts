# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/initial daemon/portmap virtual/net"
	iset daemon_stops_badly

	iset exec daemon = "@rpc.mountd@ -F"

	idone
}

