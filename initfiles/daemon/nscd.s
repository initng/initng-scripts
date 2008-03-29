# SERVICE: daemon/nscd
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset exec daemon = "@/usr/sbin/nscd@ --debug"
	idone
}
