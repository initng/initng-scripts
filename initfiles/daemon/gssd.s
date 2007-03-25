# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/initial daemon/portmap virtual/net"

	iexec daemon = "@rpc.gssd@ -f"

	idone
}

