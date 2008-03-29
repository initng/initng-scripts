# SERVICE: daemon/fnfxd
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset use = daemon/acpid
		iset pid_file = "/var/run/fnfxd.pid"
		iset forks
		iset exec daemon = "@fnfxd@"
	idone
}
