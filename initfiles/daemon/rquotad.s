# SERVICE: daemon/rquotad
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/initial virtual/portmap virtual/net
		iset exec daemon = "@rpc.rquotad@ -f"
	idone
}
