# SERVICE: system/coldplug/isapnp
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial
		iset use = system/modules/depmod system/modules
		iset syncron = coldplug
		iset exec start = "/etc/hotplug/isapnp.rc start"
		iset exec stop = "/etc/hotplug/isapnp.rc stop"
	idone
}
