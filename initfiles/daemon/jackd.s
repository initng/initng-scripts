# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="daemon/jackd"
	iregister daemon
	iset need = "system/bootmisc"
	iset use = "system/coldplug service/alsasound"
	iset exec daemon = "@/usr/bin/jackd@ -R -d alsa -d hw:0"
	idone
}
