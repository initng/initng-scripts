# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/jackd && {
		iset need = system/bootmisc
		iset use = system/coldplug service/alsasound
		iset exec daemon = "@/usr/bin/jackd@ -R -d alsa -d hw:0"
	}
}
