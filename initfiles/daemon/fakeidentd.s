# SERVICE: daemon/fakeidentd
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset pid_file = "/var/run/fakeidentd.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/fakeidentd@ mafteah"
	idone
}
