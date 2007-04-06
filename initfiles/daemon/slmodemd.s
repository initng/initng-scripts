# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/slmodemd
	iset need = system/bootmisc service/alsasound
	iset exec daemon = "@/usr/sbin/slmodemd@ --country"
	idone
}
