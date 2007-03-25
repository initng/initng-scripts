# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/bootmisc"

	iexec start = "@/usr/sbin/hid2hci@ -0"
	iexec stop = "@/usr/sbin/hid2hci@ -1"

	idone
}

