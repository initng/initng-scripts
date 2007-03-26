# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/bootmisc"

	iset exec start = "@/usr/sbin/upsdrvctl@ start"
	iset exec stop = "@/usr/sbin/upsdrvctl@ stop"

	idone
}

