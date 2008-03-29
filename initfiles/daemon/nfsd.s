# SERVICE: daemon/nfsd
# NAME:
# DESCRIPTION:
# WWW:

#ifd gentoo
RPCNFSDCOUNT="8"
[ -f /etc/conf.d/nfs ] && . /etc/conf.d/nfs
#elsed fedora mandriva
[ -f /etc/sysconfig/nfs ] && . /etc/sysconfig/nfs
#endd

setup() {
	iregister daemon
		iset need = system/initial virtual/portmap
#ifd gentoo
		iset need = virtual/net
		iexec daemon
		iexec kill
#elsed
		iset pid_of = rpc.nfsd
		iset exec daemon = "@rpc.nfsd@ ${RPCNFSDARGS} ${RPCNFSDCOUNT}"
#endd
	idone
}

#ifd gentoo
daemon() {
	@/sbin/rpc.lockd@
	exec @/usr/sbin/rpc.nfsd@ ${RPCNFSDCOUNT}
}

kill() {
	@/bin/killall@ -2 nfsd
}
#endd
