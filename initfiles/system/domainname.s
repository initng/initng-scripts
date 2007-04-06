# NAME:
# DESCRIPTION:
# WWW:

source /etc/conf.d/domainname

setup()
{
	ireg service system/domainname
	iset need = "system/initial"
	iexec start
	idone
}

start()
{
	[ -n "${NISDOMAIN}" ] && @/bin/domainname@ "${NISDOMAIN}"
}
