# NAME:
# DESCRIPTION:
# WWW:

source /etc/conf.d/domainname

setup()
{
	iregister service
	iset      need = "system/initial"
	iexec     start
	idone
}

start()
{
	[ -n "${NISDOMAIN}" ] && @/bin/domainname@ "${NISDOMAIN}"
}
