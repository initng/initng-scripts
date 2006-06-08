#!/sbin/runiscript

setup()
{
    iregister service
	iset critical
	iset need = "initial mountroot checkfs"
	iset use = "sraid hdparm selinux/relabel"
	
	iexec start
	iexec stop
		
	# Tell initng this service is done parsing.
    idone
}

start()
{
#ifd debian
		echo "Mounting local filesystems"
		@mount@ -a -t proc >/dev/null 2>&1
		# Ignore error message due to /proc already being mounted
		ES_TO_REPORT=${?}
		@mount@ -a -v -t noproc,nfs,nfs4,smbfs,cifs,ncp,ncpfs,coda,ocfs2,gfs
		ES=${?}
		ES_TO_REPORT=$((${ES_TO_REPORT} | ${ES}))
		[ 0 != ${ES_TO_REPORT} ] && echo "code ${ES_TO_REPORT}"
#elsed
		@awk@ 'NF && $1!~/^#/ && $2!="/" && $3~/reiserfs|reiser4|ext2|ext3|xfs|jfs|vfat|ntfs|tmpfs|subfs|bind/ && $4!~/(^|,)noauto(,|$)/ {print $2}' /etc/fstab | @sort@ | while read mp
		do
			@mount@ "${mp}" || echo "WARNING, failed to mount ${mp}"
		done
#endd
		exit 0
}

stop()
{
		echo "Sending all processes the TERM signal ..."
		@killalli5:killall5@ -15
		sleep 3
		echo "Sending all processes the KILL signal ..."
		@killalli5:killall5@ -9
		sleep 1

		@awk@ 'NF && $1!~/^#/ && $2!~/^\/(|proc|sys|dev)$/ {print $2}' /etc/mtab | @sort@ -r | while read mp
		do
			@umount@ "${mp}" || echo "WARNING, failed to umount ${mp}"
		done
		exit 0
}
