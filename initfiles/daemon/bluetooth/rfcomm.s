# SERVICE: daemon/bluetooth/rfcomm
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/bootmisc daemon/bluetooth/hcid
		iset exec start = "@/usr/bin/rfcomm@ -f /etc/bluetooth/rfcomm.conf bind all"
		iset exec stop = "@/usr/bin/rfcomm@ -f /etc/bluetooth/rfcomm.conf release all"
	idone
}
