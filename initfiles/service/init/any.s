# SERVICE: service/init/*
# NAME:
# DESCRIPTION:
# WWW:

#ifd fedora
RCDIR="/etc/rc.d/init.d"
#elsed
RCDIR="/etc/init.d"
#endd

setup()
{
	iregister service
		iset need = system/bootmisc system/mountfs
		iset exec start = "${RCDIR}/${NAME} start"
		iset exec stop = "${RCDIR}/${NAME} stop"
	idone
}
