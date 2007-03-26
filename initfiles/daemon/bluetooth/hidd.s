# NAME:
# DESCRIPTION:
# WWW:

HIDD_OPTIONS="--server"
#ifd gentoo
source /etc/conf.d/bluetooth
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/bluetooth/hcid daemon/bluetooth/sdpd"
	iset forks
	iset pid_of = hidd

	iset exec daemon = "@/usr/bin/hidd@ ${HIDD_OPTIONS}"

	idone
}
