# NAME: 
# DESCRIPTION: 
# WWW: 

#ifd debian linspire
OPTIONS=""
source /etc/default/portmap
#elsed
PORTMAP_OPTS=""
source /etc/conf.d/portmap
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset forks
	iset pid_of = portmap

#ifd debian linspire
	iset exec daemon = "@/sbin/portmap@ ${OPTIONS}"
#elsed
	iset exec daemon = "@/sbin/portmap@ -d ${PORTMAP_OPTS}"
#endd

	idone
}

