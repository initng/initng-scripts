# NAME:
# DESCRIPTION:
# WWW:

#ifd gentoo
RPCNFSDCOUNT =" 8"
source /etc/conf.d/nfs
#elsed
#ifd fedora mandriva
source /etc/sysconfig/nfs
#endd
#endd

setup()
{
#ifd gentoo
	iregister -s "daemon/nfsd" service
#elsed
	iregister -s "daemon/nfsd" service
#endd

#ifd gentoo
	iset -s "daemon/nfsd" need = "system/initial daemon/portmap virtual/net"
#elsed
	iset -s "daemon/nfsd" need = "system/initial daemon/portmap"
	iset -s "daemon/nfsd" pid_of = rpc.nfsd
#endd

#ifd gentoo
	iexec -s "daemon/nfsd" start = nfsd_start
	iexec -s "daemon/nfsd" stop = nfsd_stop
#elsed
	iexec -s "daemon/nfsd" daemon = "@rpc.nfsd@ ${RPCNFSDARGS} ${RPCNFSDCOUNT}"
#endd

#ifd gentoo
	idone -s "daemon/nfsd"
#elsed
	idone -s "daemon/nfsd"
#endd
}

#ifd gentoo
nfsd_start()
{
	    /sbin/rpc.lockd
	    /usr/sbin/rpc.nfsd ${RPCNFSDCOUNT}
}

nfsd_stop()
{
	    /bin/killall -2 nfsd
}
#endd
