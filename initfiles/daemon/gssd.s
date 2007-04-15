# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/gssd && {
		iset need = system/initial daemon/portmap virtual/net
		iset exec daemon = "@rpc.gssd@ -f"
	}
}
