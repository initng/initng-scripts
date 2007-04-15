# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service service/athcool && {
		iset need = system/bootmisc
		iset exec start = "@/usr/sbin/athcool@ on"
		iset exec stop = "@/usr/sbin/athcool@ off"
	}
}
