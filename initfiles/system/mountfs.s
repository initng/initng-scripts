# NAME:
# DESCRIPTION:
# WWW:

NET_FS =" afs,cifs,coda,davfs,gfs,ncpfs,nfs,nfs4,ocfs2,shfs,smbfs"

setup()
{
	iregister -s "system/mountfs/essential" service
	iregister -s "system/mountfs/home" service
	iregister -s "system/mountfs/network" service
	iregister -s "system/mountfs" service

	iset -s "system/mountfs/essential" need = "system/initial/mountvirtfs system/mountroot system/checkfs"
	iset -s "system/mountfs/essential" use = "system/sraid system/hdparm system/selinux/relabel"
	iset -s "system/mountfs/essential" critical
	iset -s "system/mountfs/essential" never_kill
	iset -s "system/mountfs/home" need = "system/mountroot system/checkfs"
	iset -s "system/mountfs/home" never_kill
	iset -s "system/mountfs/network" need = "system/initial system/mountfs/essential virtual/net"
	iset -s "system/mountfs/network" use = "daemon/portmap"
	iset -s "system/mountfs/network" never_kill
	iset -s "system/mountfs" need = "system/mountfs/essential system/mountfs/home"
	iset -s "system/mountfs" use = "system/mountfs/network"
	iset -s "system/mountfs" never_kill

	iexec -s "system/mountfs/essential" start = essential_start
	iexec -s "system/mountfs/essential" stop = essential_stop
	iexec -s "system/mountfs/home" start = home_start
	iexec -s "system/mountfs/network" start = network_start
	iexec -s "system/mountfs/network" stop = network_stop
	iexec -s "system/mountfs" start = mountfs_start

	idone -s "system/mountfs/essential"
	idone -s "system/mountfs/home"
	idone -s "system/mountfs/network"
	idone -s "system/mountfs"
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
		@mount@ -a -F -t ${NET_FS} ||
			@mount@ -a -t ${NET_FS}
}

network_stop()
{
		@umount@ -a -f -t ${NET_FS}
}

mountfs_start()
{
		@mount@ -a -v -t reiserfs,reiser4,reiserfs,reiser4,ext2,ext3,xfs,jfs,vfat,ntfs,ntfs-3g,tmpfs,subfs,bind,auto
		exit 0
}
