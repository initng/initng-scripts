# NAME:
# DESCRIPTION:
# WWW:

#ifd gentoo
RPCNFSDCOUNT="8"
source /etc/conf.d/nfs
#elsed fedora mandriva
source /etc/sysconfig/nfs
#endd

setup()
{
	ireg daemon daemon/nfsd
	iset need = system/initial daemon/portmap
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
daemon()
{
	@/sbin/rpc.lockd@
	exec @/usr/sbin/rpc.nfsd@ ${RPCNFSDCOUNT}
}

kill()
{
	@/bin/killall@ -2 nfsd
}
#endd
