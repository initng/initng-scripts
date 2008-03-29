# SERVICE: daemon/imapd
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/initial daemon/portmap virtual/net
		iset exec daemon = "@rpc.idmapd@ -f"
	idone
}
