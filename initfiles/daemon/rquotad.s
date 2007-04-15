# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/rquotad && {
		iset need = system/initial daemon/portmap virtual/net
		iset exec daemon = "@rpc.rquotad@ -f"
	}
}
