# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/ulogd
	iset need = system/bootmisc
	iset exec daemon = "@/usr/sbin/ulogd@"
	idone
}
