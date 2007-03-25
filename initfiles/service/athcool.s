# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/bootmisc"

	iexec start = "@/usr/sbin/athcool@ on"
	iexec stop = "@/usr/sbin/athcool@ off"

	idone
}

