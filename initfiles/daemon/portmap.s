# NAME:
# DESCRIPTION:
# WWW:

#ifd debian linspire
. /etc/default/portmap
#elsed
[ -f /etc/conf.d/portmap ] && . /etc/conf.d/portmap
#endd

setup()
{
	ireg daemon daemon/portmap
	iset need = system/bootmisc virtual/net
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
