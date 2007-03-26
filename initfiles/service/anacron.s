# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/bootmisc"
	iset exec start = "@/usr/sbin/anacron@ -s"


	idone
}
