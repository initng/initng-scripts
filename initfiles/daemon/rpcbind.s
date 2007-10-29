# SERVICE: daemon/rpcbind
# NAME:
# DESCRIPTION:
# WWW:

RPCBIND_ARGS=
#. /etc/sysconfig/rpcbind

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net virtual/net/lo
		iset provide = virtual/portmap
		iset forks
		iset pid_of = rpcbind
		iset exec daemon = /sbin/rpcbind $RPCBIND_ARGS
	idone
}
