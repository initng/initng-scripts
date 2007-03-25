# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/bootmisc system/usb"
	iset provide = "virtual/net"

	iexec start = "@eciadsl-start@"
	iexec stop = "@eciadsl-stop@"

	idone
}

