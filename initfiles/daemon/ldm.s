# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset use = "daemon/xfs system/modules system/coldplug"
	iset nice = -4

	iset exec daemon = "@/usr/bin/ldm@"

	idone
}

