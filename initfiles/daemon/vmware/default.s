# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg virtual daemon/vmware && {
		iset need = system/bootmisc daemon/vmware/vmnet system/modules/vmmon
		iset use = daemon/vmware/vmware-serverd
		iset also_stop = daemon/vmware/vmnet
	}
}
