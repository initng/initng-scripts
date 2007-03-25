# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/vmware/vmnet system/modules/vmmon"

	iexec daemon = "@/opt/vmware/server/sbin/vmware-serverd@"

	idone
}

