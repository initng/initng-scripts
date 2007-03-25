# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/bootmisc daemon/bluetooth/hcid"

	iexec start = "@/usr/bin/rfcomm@ -f /etc/bluetooth/rfcomm.conf bind all"
	iexec stop = "@/usr/bin/rfcomm@ -f /etc/bluetooth/rfcomm.conf release all"

	idone
}

