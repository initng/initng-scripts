# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/vmware/vmware-serverd
	iset need = system/bootmisc daemon/vmware/vmnet system/modules/vmmon
	iset exec daemon = "@/opt/vmware/server/sbin/vmware-serverd@"
	idone
}
