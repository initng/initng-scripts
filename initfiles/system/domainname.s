# SERVICE: system/domainname
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial
		iexec start
	idone
}

start() {
	[ -f /etc/conf.d/domainname ] && . /etc/conf.d/domainname
	[ -n "${NISDOMAIN}" ] && @/bin/domainname@ "${NISDOMAIN}"
}
