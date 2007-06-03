# SERVICE: daemon/bluetooth/hidd
# NAME:
# DESCRIPTION:
# WWW:

HIDD_OPTIONS="--server"
#ifd gentoo
[ -f /etc/conf.d/bluetooth ] && . /etc/conf.d/bluetooth
#endd

setup()
{
	iregister daemon
		iset need = system/bootmisc daemon/bluetooth/hcid \
		            daemon/bluetooth/sdpd
		iset forks
		iset pid_of = hidd
		iset exec daemon = "@/usr/bin/hidd@ ${HIDD_OPTIONS}"
	idone
}
