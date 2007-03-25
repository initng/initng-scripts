# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister virtual

	iset need = "system/bootmisc daemon/bluetooth/hcid daemon/bluetooth/sdpd"
	iset also_stop = daemon/bluetooth/hcid daemon/bluetooth/sdpd


	idone
}

