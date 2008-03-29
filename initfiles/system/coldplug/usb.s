# SERVICE: system/coldplug/usb
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/coldplug/pci system/initial
		iset use = system/modules/depmod system/modules
		iset syncron = coldplug
		iset exec start = "/etc/hotplug/usb.rc start"
		iset exec stop = "/etc/hotplug/usb.rc stop"
	idone
}
