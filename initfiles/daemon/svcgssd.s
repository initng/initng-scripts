# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/initial daemon/portmap"

	iexec daemon = "@rpc.svcgssd@ -f"

	idone
}

