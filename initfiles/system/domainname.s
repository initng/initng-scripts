# NAME:
# DESCRIPTION:
# WWW:

[ -f /etc/conf.d/domainname ] && source /etc/conf.d/domainname

setup()
{
	ireg service system/domainname
	iset need = system/initial
	iexec start
	idone
}

start()
{
	[ -n "${NISDOMAIN}" ] && @/bin/domainname@ "${NISDOMAIN}"
}
