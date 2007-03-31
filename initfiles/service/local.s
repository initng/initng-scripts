# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="service/local"
	iregister service
	iset need = "system/bootmisc"
	iset use = "system/coldplug"
#ifd fedora mandriva
	iset exec start = "/etc/rc.d/rc.local"
#elsed
	iset exec start = "/etc/conf.d/local.start"
	iset exec stop = "/etc/conf.d/local.stop"
#endd
	idone
}
