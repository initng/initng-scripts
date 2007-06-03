# SERVICE: daemon/gssd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/initial daemon/portmap virtual/net
		iset exec daemon = "@rpc.gssd@ -f"
	idone
}
