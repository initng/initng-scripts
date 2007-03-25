# NAME:
# DESCRIPTION:
# WWW:

source /etc/conf.d/domainname

setup()
{
	iregister service

	iset need = "system/initial"

	iexec start = domainname_start

	idone
}

domainname_start()
{
		[ -n ${NISDOMAIN} ] && @/bin/domainname@ "${NISDOMAIN}"
}
