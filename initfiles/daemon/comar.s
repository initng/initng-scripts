# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/comar && {
		iset need = system/bootmisc
		iset exec daemon = "@/usr/bin/comar@"
	}
}
