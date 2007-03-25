# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/bootmisc daemon/bluetooth/hcid"

	iexec start = "@/usr/sbin/hciattach@ ${NAME}"

	idone
}

