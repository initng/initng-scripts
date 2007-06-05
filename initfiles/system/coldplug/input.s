# SERVICE: system/coldplug/input
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/initial system/coldplug/pci
		iset use = system/modules/depmod system/modules \
		           system/coldplug/isapnp
		iset syncron = coldplug
		iset exec start = "/etc/hotplug/input.rc start"
		iset exec stop = "/etc/hotplug/input.rc stop"
	idone
}
