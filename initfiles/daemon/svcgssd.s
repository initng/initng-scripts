# SERVICE: daemon/svcgssd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/initial daemon/portmap
		iset exec daemon = "@rpc.svcgssd@ -f"
	idone
}
