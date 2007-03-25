# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/bootmisc"
	iset use = "system/modules system/coldplug"
	iset stdall = /var/log/wifi-radar.log

	iexec start = "@/usr/sbin/wifi-radar@ -d"

	idone
}

