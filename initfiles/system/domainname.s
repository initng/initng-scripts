# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service system/domainname && {
		iset need = system/initial
		iexec start
	}
}

start()
{
	[ -f /etc/conf.d/domainname ] && . /etc/conf.d/domainname
	[ -n "${NISDOMAIN}" ] && @/bin/domainname@ "${NISDOMAIN}"
}
