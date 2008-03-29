# SERVICE: system/coldplug/scsi
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial system/coldplug/pci
		iset use = system/modules/depmod system/modules
		iset syncron = coldplug
		iset exec start = "/etc/hotplug/scsi.rc start"
		iset exec stop = "/etc/hotplug/scsi.rc stop"
	idone
}
