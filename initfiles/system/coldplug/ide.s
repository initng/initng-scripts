# SERVICE; system/coldplug/ide
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial system/coldplug/pci
		iset use = system/modules/depmod system/modules
		iset syncron = coldplug
		iset exec start = "/etc/hotplug/ide.rc start"
		iset exec stop = "/etc/hotplug/ide.rc stop"
	idone
}
