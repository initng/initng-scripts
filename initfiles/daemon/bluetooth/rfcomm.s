# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service daemon/bluetooth/rfcomm
	iset need = system/bootmisc daemon/bluetooth/hcid
	iset exec start = "@/usr/bin/rfcomm@ -f /etc/bluetooth/rfcomm.conf bind all"
	iset exec stop = "@/usr/bin/rfcomm@ -f /etc/bluetooth/rfcomm.conf release all"
	idone
}
