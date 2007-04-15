# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service service/anacron && {
		iset need = system/bootmisc
		iset exec start = "@/usr/sbin/anacron@ -s"
	}
}
