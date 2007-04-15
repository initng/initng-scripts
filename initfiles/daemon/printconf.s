# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service daemon/printconf && {
		iset need = system/bootmisc
		iset exec start = "@/usr/sbin/printconf-backend@"
	}
}
