# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg virtual daemon/bluetooth
	iset need = system/bootmisc daemon/bluetooth/{hcid,sdpd}
	iset also_stop = daemon/bluetooth/{hcid,sdpd}
	idone
}
