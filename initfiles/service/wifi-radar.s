# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/bootmisc"
	iset use = "system/modules system/coldplug"
	iset exec start = "@/usr/sbin/wifi-radar@ -d"
	iset stdall = "/var/log/wifi-radar.log"

	idone
}
