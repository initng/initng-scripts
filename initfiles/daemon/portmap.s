# SERVICE: daemon/portmap
# NAME:
# DESCRIPTION:
# WWW:

#ifd debian linspire
[ -f /etc/default/portmap ] && . /etc/default/portmap
#elsed
[ -f /etc/conf.d/portmap ] && . /etc/conf.d/portmap
#endd

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset provide = virtual/portmap
#ifd debian linspire
		iset forks
		iset pid_of = portmap
		iset exec daemon = "@/sbin/portmap@ ${OPTIONS}"
#elsed
		iset exec daemon = "@/sbin/portmap@ -d ${PORTMAP_OPTS}"
#endd
	idone
}
