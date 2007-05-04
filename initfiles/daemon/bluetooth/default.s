# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg virtual daemon/bluetooth && {
		iset need = system/bootmisc daemon/bluetooth/hcid \
			    daemon/bluetooth/sdpd
		iset also_stop = daemon/bluetooth/hcid daemon/bluetooth/sdpd
	}
}
