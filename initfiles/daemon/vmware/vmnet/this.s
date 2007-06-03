# SERVICE: daemon/vmware/vmnet
# NAME:
# DESCRIPTION:
# WWW:

# Making this a need, rather than a use.  Shouldn't break anything, if the
# nodes exist, they won't be re-made

setup()
{
	iregister daemon
		iset need = system/bootmisc daemon/vmware/vmnet/prepare
		iset exec daemon = "@/opt/vmware/bin/vmnet-bridge@ /dev/vmnet0 eth0"
	idone
}
