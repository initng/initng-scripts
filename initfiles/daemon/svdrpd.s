# NAME: 
# DESCRIPTION: 
# WWW: 

VDR_HOST="localhost"
VDR_PORT="2002"
SERV_HOST="localhost"
SERV_PORT="2001"
source /etc/conf.d/svdrpd

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset use = "daemon/vdr"
	iset respawn

	iset exec daemon = "@/usr/bin/svdrpd@ ${VDR_HOST} ${VDR_PORT} ${SERV_HOST} ${SERV_PORT}"

	idone
}

