# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/imapd
	iset need = system/initial daemon/portmap virtual/net
	iset exec daemon = "@rpc.idmapd@ -f"
	idone
}
