# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service service/pppoe && {
		iset need = system/bootmisc system/modules system/hostname
		iset use = system/modules system/coldplug
		iset provide = virtual/net
		iset stdout = "/dev/null"
		iset exec start = "@adsl-start:adsl-connect:pppoe-start:pppoe-connect@"
		iset exec stop = "@adsl-stop:pppoe-stop@"
	}
}
