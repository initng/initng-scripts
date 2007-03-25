# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/bootmisc system/modules system/hostname"
	iset use = "system/modules system/coldplug"
	iset provide = "virtual/net"
	iset stdout = /dev/null

	iexec start = "@adsl-start:adsl-connect:pppoe-start:pppoe-connect@"
	iexec stop = "@adsl-stop:pppoe-stop@"

	idone
}

