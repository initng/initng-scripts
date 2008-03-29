# SERVICE: daemon/pbbuttonsd
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = service/alsasound virtual/net/lo
		iset exec daemon = "@/usr/bin/pbbuttonsd@"
	idone
}
