# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/initial daemon/portmap virtual/net"

	iexec daemon = "@rpc.statd@ -F"

	idone
}
