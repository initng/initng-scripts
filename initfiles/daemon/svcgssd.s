# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/svcgssd
	iset need = system/initial daemon/portmap
	iset exec daemon = "@rpc.svcgssd@ -f"
	idone
}
