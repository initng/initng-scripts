# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/bootmisc"
	iset exec start = "@/usr/sbin/athcool@ on"
	iset exec stop = "@/usr/sbin/athcool@ off"

	idone
}
