# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/bluetooth/dund
	iset need = system/bootmisc daemon/bluetooth/hcid daemon/bluetooth/sdpd
	iset exec daemon = "@/usr/bin/dund@ --listen --persist --nodetach"
	idone
}
