# SERVICE: system/mountfs/network
# NAME:
# DESCRIPTION:
# WWW:

NET_FS="afs,cifs,coda,davfs,gfs,ncpfs,nfs,nfs4,ocfs2,shfs,smbfs"

setup()
{
	iregister service
		iset need = system/initial system/mountfs/essential \
			    virtual/net
		iset use = daemon/portmap
		iset never_kill
		iexec start
		iset exec stop = "@umount@ -a -f -t ${NET_FS}"
	idone
}

start()
{
	@mount@ -a -F -t "${NET_FS}" 2>/dev/null ||
	@mount@ -a -t "${NET_FS}"
}
