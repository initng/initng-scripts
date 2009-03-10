# SERVICE: service/local
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/bootmisc
		iset use = system/coldplug
#ifd fedora mandriva
		iset exec start = "/etc/rc.d/rc.local"
#elsed gentoo
		iset exec start = "/etc/conf.d/local.start"
		iset exec stop = "/etc/conf.d/local.stop"
#elsed
		iset exec start = "/etc/rc.local"
#endd
	idone
}
