# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/bootmisc"

	iset exec start = "@/usr/sbin/hid2hci@ -0"
	iset exec stop = "@/usr/sbin/hid2hci@ -1"

	idone
}
