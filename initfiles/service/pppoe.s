# SERVICE: service/pppoe
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/bootmisc system/hostname
		iset use = system/modules system/coldplug
		iset provide = virtual/net
		iset stdout = "/dev/null"
		iset exec start = "@adsl-start:adsl-connect:pppoe-start:pppoe-connect@"
		iset exec stop = "@adsl-stop:pppoe-stop@"
	idone
}
