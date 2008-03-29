# SERVICE: daemon/mdnsd
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset pid_file = "/var/run/mdnsd.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/mdnsd@"
	idone
}
