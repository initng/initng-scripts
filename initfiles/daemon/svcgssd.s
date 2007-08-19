# SERVICE: daemon/svcgssd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/initial virtual/portmap
		iset exec daemon = "@rpc.svcgssd@ -f"
	idone
}
