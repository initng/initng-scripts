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
	iexec daemon = "@/sbin/portmap@ ${OPTIONS}"
#elsed
	iexec daemon = "@/sbin/portmap@ -d ${PORTMAP_OPTS}"
#endd

	idone
}

