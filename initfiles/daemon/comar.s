# SERVICE: daemon/comar
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset exec daemon = "@/usr/bin/comar@"
	idone
}
