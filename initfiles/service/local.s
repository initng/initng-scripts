# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/bootmisc"
	iset use = "system/coldplug"

#ifd fedora mandriva
	iexec start = "/etc/rc.d/rc.local"
#elsed
	iexec start = "/etc/conf.d/local.start"
	iexec stop = "/etc/conf.d/local.stop"
#endd

	idone
}

