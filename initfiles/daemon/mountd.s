# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/mountd
	iset need = system/initial daemon/portmap virtual/net
	iset daemon_stops_badly
	iset exec daemon = "@rpc.mountd@ -F"
	idone
}
