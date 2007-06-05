# SERVICE: system/coldplug/pci
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/initial
		iset use = system/modules/depmod system/modules
		iset syncron = coldplug
		iset exec start = "/etc/hotplug/pci.rc start"
		iset exec stop = "/etc/hotplug/pci.rc stop"
	idone
}
