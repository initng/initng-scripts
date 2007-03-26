# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister virtual

	iset need = "system/bootmisc daemon/vmware/vmnet system/modules/vmmon"
	iset use = "daemon/vmware/vmware-serverd"
	iset also_stop = daemon/vmware/vmnet

	idone
}
