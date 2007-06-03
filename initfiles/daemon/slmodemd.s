# SERVICE: daemon/slmodemd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc service/alsasound
		iset exec daemon = "@/usr/sbin/slmodemd@ --country"
	idone
}
