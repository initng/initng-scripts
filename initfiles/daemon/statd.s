# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/statd
	iset need = system/initial daemon/portmap virtual/net
	iset exec daemon = "@rpc.statd@ -F"
	idone
}
