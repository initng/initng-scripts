# SERVICE: daemon/ulogd
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset exec daemon = "@/usr/sbin/ulogd@"
	idone
}
