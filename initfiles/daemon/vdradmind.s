# SERVICE: daemon/vdradmin
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset use = daemon/vdr daemon/svdrpd
		iset stdout = /dev/null
		iset exec daemon = "@vdradmind.pl@ --nofork"
	idone
}
