# SERVICE: daemon/jackd
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset use = system/coldplug service/alsasound
		iset exec daemon = "@/usr/bin/jackd@ -R -d alsa -d hw:0"
	idone
}
