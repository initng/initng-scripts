# NAME:
# DESCRIPTION:
# WWW:

#ifd debian linspire
source /etc/default/portmap
#elsed
source /etc/conf.d/portmap
#endd

setup()
{
	export SERVICE="daemon/portmap"
	iregister daemon
	iset need = "system/bootmisc virtual/net"
	iset forks
	iset pid_of = portmap
	iexec daemon
	idone
}

daemon()
{
#ifd debian linspire
	exec @/sbin/portmap@ ${OPTIONS}
#elsed
	exec @/sbin/portmap@ -d ${PORTMAP_OPTS}
#endd
}
