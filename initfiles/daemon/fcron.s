# SERVICE: daemon/fcron
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net/lo
		iset pid_file = "/var/run/fcron.pid"
		iset respawn
		iset forks
		iset exec daemon = "@/usr/sbin/fcron@"
	idone
}
