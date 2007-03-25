# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/bootmisc"

	iexec start = "@/usr/sbin/upsdrvctl@ start"
	iexec stop = "@/usr/sbin/upsdrvctl@ stop"

	idone
}

