# SERVICE: system/mountfs
# NAME:
# DESCRIPTION:
# WWW:

NET_FS="afs,cifs,coda,davfs,gfs,ncpfs,nfs,nfs4,ocfs2,shfs,smbfs"
LOCAL_FS="reiserfs,reiser4,reiserfs,reiser4,ext2,ext3,xfs,jfs,vfat,ntfs,ntfs-3g,tmpfs,subfs,bind,auto"

setup()
{
	iregister service
		iset need = system/mountfs/essential system/mountfs/home
		iset use = system/mountfs/network
		iset never_kill
		iset start_fail_ok
		iset exec start = "@mount@ -a -v -t ${LOCAL_FS}"
	idone
}
