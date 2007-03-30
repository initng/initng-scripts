# NAME:
# DESCRIPTION:
# WWW:

NET_FS="afs,cifs,coda,davfs,gfs,ncpfs,nfs,nfs4,ocfs2,shfs,smbfs"
LOCAL_FS="reiserfs,reiser4,reiserfs,reiser4,ext2,ext3,xfs,jfs,vfat,ntfs,ntfs-3g,tmpfs,subfs,bind,auto"

setup()
{
	export SERVICE="system/mountfs/essential"
	iregister service
	iset need = "system/initial/mountvirtfs system/mountroot system/checkfs"
	iset use = "system/sraid system/hdparm system/selinux/relabel"
	iset critical
	iset never_kill
	iexec start = essential_start
	iexec stop = essential_stop
	idone

	export SERVICE="system/mountfs/home"
	iregister service
	iset need = "system/mountroot system/checkfs"
	iset never_kill
	iexec start = home_start
	idone

	export SERVICE="system/mountfs/network"
	iregister service
	iset need = "system/initial system/mountfs/essential virtual/net"
	iset use = "daemon/portmap"
	iset never_kill
	iexec start = network_start
	iexec stop = network_stop
	idone

	export SERVICE="system/mountfs"
	iregister service
	iset need = "system/mountfs/essential system/mountfs/home"
	iset use = "system/mountfs/network"
	iset never_kill
	iexec start = mountfs_start
	idone
}

essential_start()
{
	for mp in /tmp /usr /var /srv /opt
	do
		@grep@ -q "[[:space:]]${mp}[[:space:]]" /etc/fstab &&
		@mount@ -v "${mp}" &
	done
	wait
	exit 0
}

essential_stop()
{
	echo "Sending all processes the TERM signal ..."
	@killalli5:killall5@ -15
	sleep 3
	echo "Sending all processes the KILL signal ..."
	@killalli5:killall5@ -9
	sleep 1

	@sed@ 's:^\S*\s*::' /etc/mtab | @sort@ -r | while read mp drop
	do
		case "${mp}" in
			/proc|/sys|/dev|/usr|/) ;;
			*)
				@umount@ -r -d -f "${mp}" ||
				echo "WARNING, failed to umount ${mp}" &
				;;
		esac
	done

	@umount@ -r -d -f /usr || echo "WARNING, failed to umount /usr" &
	wait
	exit 0
}

home_start()
{
	@grep@ -q "[[:space:]]/home[[:space:]]" /etc/fstab &&
		@mount@ -v /home
	exit 0
}

network_start()
{
	@mount@ -a -F -t "${NET_FS}" ||
		@mount@ -a -t "${NET_FS}"
}

network_stop()
{
	@umount@ -a -f -t "${NET_FS}"
}

mountfs_start()
{
	@mount@ -a -v -t "${LOCAL_FS}"
	exit 0
}
