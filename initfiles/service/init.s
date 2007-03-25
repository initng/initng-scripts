# NAME: 
# DESCRIPTION: 
# WWW: 

#ifd fedora
RCDIR =" /etc/rc.d/init.d"
#elsed
RCDIR =" /etc/init.d"
#endd

setup()
{
	iregister service

	iset need = "system/bootmisc"
	iset last

	iexec start = "${RCDIR}/${NAME} start"
	iexec stop = "${RCDIR}/${NAME} stop"

	idone
}

