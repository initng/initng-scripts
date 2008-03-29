# SERVICE: system/mountfs
# NAME:
# DESCRIPTION:
# WWW:

LOCAL_FS="reiserfs,reiser4,reiserfs,reiser4,ext2,ext3,xfs,jfs,vfat,ntfs,ntfs-3g,tmpfs,subfs,bind,auto"

setup() {
	iregister service
		iset need = system/mountfs/essential system/mountfs/home
		iset use = system/mountfs/network
		iset never_kill
		iexec start
	idone
}

start() {
	@mount@ -a -F -v -t ${LOCAL_FS} 2>/dev/null ||
	@mount@ -a -v -t ${LOCAL_FS}
	exit 0
}
