# SERVICE: daemon/bluetooth/pand
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc daemon/bluetooth/hcid
		iset exec daemon = "@/usr/bin/pand@ --nodetach --listen --role NAP"
	idone
}
