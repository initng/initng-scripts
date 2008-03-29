# SERVICE: daemon/bluetooth/dund
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc daemon/bluetooth/hcid \
		            daemon/bluetooth/sdpd
		iset exec daemon = "@/usr/bin/dund@ --listen --persist --nodetach"
	idone
}
