# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc system/modules"
	iset use = "system/coldplug daemon/bluetooth/rfcomm"

	iexec daemon = "@/usr/sbin/pppd@ call $NAME nodetach"

	idone
}

