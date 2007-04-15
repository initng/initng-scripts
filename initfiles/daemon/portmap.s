# NAME:
# DESCRIPTION:
# WWW:

#ifd debian linspire
[ -f /etc/default/portmap ] && . /etc/default/portmap
#elsed
[ -f /etc/conf.d/portmap ] && . /etc/conf.d/portmap
#endd

setup()
{
	ireg daemon daemon/portmap && {
		iset need = system/bootmisc virtual/net
		iset forks
		iset pid_of = portmap
#ifd debian linspire
		iset exec daemon = "@/sbin/portmap@ ${OPTIONS}"
#elsed
		iset exec daemon = "@/sbin/portmap@ -d ${PORTMAP_OPTS}"
#endd
	}
}
