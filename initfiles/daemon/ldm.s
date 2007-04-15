# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/ldm && {
		iset need = system/bootmisc
		iset use = daemon/xfs system/modules system/coldplug
		iset nice = "-4"
		iset exec daemon = "@/usr/bin/ldm@"
	}
}
