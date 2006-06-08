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
		echo "Mounting local filesystems"
		/bin/mount -a -t proc >/dev/null 2>&1
		# Ignore error message due to /proc already being mounted
		ES_TO_REPORT=${?}
		/bin/mount -a -v -t noproc,nfs,nfs4,smbfs,cifs,ncp,ncpfs,coda,ocfs2,gfs
		ES=${?}
		ES_TO_REPORT=$((${ES_TO_REPORT} | ${ES}))
		[ 0 != ${ES_TO_REPORT} ] && echo "code ${ES_TO_REPORT}"
		exit 0
}

stop()
{
		echo "Sending all processes the kill signal ..."
		/sbin/killalli5 -15
		sleep 2
		echo "Sending all processes the term signal ..."
		/sbin/killalli5 -9
		sleep 1

		/usr/bin/awk 'NF && $1!~/^#/ && $2!~/^\/(|proc|sys|dev)$/ {print $2}' /etc/mtab | /usr/bin/sort -r | while read mp
		do
			/bin/umount "${mp}" || echo "WARNING, failed to umount ${mp}"
		done
		exit 0
}
