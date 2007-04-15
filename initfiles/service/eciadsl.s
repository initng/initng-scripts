# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service service/eciadsl && {
		iset need = system/bootmisc system/usb
		iset provide = virtual/net
		iset exec start = "@eciadsl-start@"
		iset exec stop = "@eciadsl-stop@"
	}
}
