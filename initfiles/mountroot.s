#!/sbin/runiscript

dm_dir=/dev/mapper;
dm_file=${dm_dir}/control;

setup()
{
    iregister -s mountroot service
	iregister -s mountroot/check service 
	iregister -s mountroot/rootrw service
	
	# TODO, only register these if os have them
	iregister -s mountroot/dmsetup service
	iregister -s mountroot/lvm service
	iregister -s mountroot/evms service
	
	iset -s mountroot/dmsetup need = "initial modules/dm-mod"
	iset -s mountroot/lvm need = "initial modules/lvm modules/lvm-mod mountroot/dmsetup"
	iset -s mountroot/evms need = "initial"
	iset -s mountroot/check need = "initial"
	iset -s mountroot/check use = "mountroot/evms mountroot/lvm mountroot/dmsetup"
	iset -s mountroot/rootrw need = "initial mountroot/check"
	iset -s mountroot/rootrw use = "mountroot/evms mountroot/lvm mountroot/dmsetup"
	iset -s mountroot need =  "initial mountroot/rootrw"

	
	# mountroot/check cant fail!
	iset -s mountroot/check critical
	iset -s mountroot/check never_kill
	iset -s mountroot/rootrw critical
	iset -s mountroot/rootrw never_kill

	# execute targets:
	iset -s mountroot/dmsetup exec start = "/sbin/dmsetup mknodes"
	iset -s mountroot/evms exec start = "/sbin/evms_activate"
	iexec -s mountroot/lvm start = lvm_start
	iexec -s mountroot/check start = check_start
	iexec -s mountroot/rootrw start = rootrw_start
	iexec -s mountroot/rootrw stop = rootrw_stop
	iexec -s mountroot start = mountroot_start
	
	# Tell initng this service is done parsing.
    idone -s mountroot/dmsetup
	idone -s mountroot/lvm
	idone -s mountroot/evms
	idone -s mountroot/check
	idone -s mountroot/rootrw
	idone -s mountroot 
}

lvm_start()
{
		/bin/mknod --mode=600 /dev/lvm c 109 0
		if [ ! -f /dev/.devfsd ]
		then
			major=`/bin/grep "[0-9] misc$" /proc/devices | /bin/sed 's/[ ]\+misc//'`
			minor=`/bin/grep "[0-9] device-mapper$" /proc/misc | /bin/sed 's/[ ]\+device-mapper//'`
			[ -d ${dm_dir} ] || /bin/mkdir --mode=755 ${dm_dir}
			[ -c ${dm_file} -o -z "${major}" -o -z "${minor}" ] || /bin/mknod --mode=600 ${dm_file} c ${major} ${minor}
		fi
		/sbin/vgscan --ignorelockingfailure --mknodes
		/sbin/vgchange --ignorelockingfailure -a y
}

check_start()
{
		retval=0
		if [ ! -f /fastboot ]
		then
			if [ -f /forcefsck ]
			then
				echo "Checking root filesystem (full fsck forced)"
				/bin/mount -n -o remount,ro /
				/sbin/logsave /dev/null /sbin/fsck -C -a -f /
				# /forcefsck isn't deleted because system/mountfs need it.
				# it'll be deleted in that script.
				retval=${?}
			else
				# Obey the fs_passno setting for / (see fstab(5))
				# - find the / entry
				# - make sure we have 6 fields
				# - see if fs_passno is something other than 0
				# t='	'
				# s="[ ${t}]"
				# d="${s}${s}*"
				# S="[^ ${t}]"
				# D="${S}${S}*"
				# /bin/sed -ne "'/^#/!s/^$s*$D$d\/$d$D$d$D$d$D$d\($D\)$s/\1/p'" /etc/fstab

				# DON'T STORE sort, awk, uniq .... ON AN OTHER PARTITION!!!
				if ! /usr/bin/awk '$1!~/^#/ && $2=="/" {exit $6}' /etc/fstab
				then
					echo "Checking root filesystem ..."
					/bin/mount -n -o remount,ro /
					/sbin/logsave /dev/null /sbin/fsck -C -T -a /
					retval=${?}
				else
					echo "Skipping root filesystem check (fstab's passno == 0) ..."
					retval=0
				fi
			fi

			if [ "${retval}" -eq 0 ]
			then
				echo "Done checking root file system."
			else
				echo "Root file system check failed with error code ${retval}."
				# If there was a failure, offer sulogin.
				#
				# NOTE: "failure" is defined as exiting with a return code of
				# 4 or larger. A return code of 1 indicates that file system
				# errors were corrected but that the boot may proceed. A return
				# code of 2 or 3 indicates that the system should immediately reboot.
				if [ "${retval}" -gt 3 ]
				then
					echo "An automatic file system check (fsck) of the root filesystem failed. 
					A manual fsck must be performed, then the system restarted. 
					The fsck should be performed in maintenance mode with the 
					root filesystem mounted in read-only mode."
					echo "The root filesystem is currently mounted in read-only mode."
					exit 1
				elif [ "${retval}" -gt 1 ]
				then
					error "The file system check corrected errors on the root partition 
						but requested that the system be restarted."
					error "The system will be restarted in 5 seconds."
					sleep 5
					echo "Will now restart"
					ngc -6
				fi
			fi
			exit 0
		fi
}

rootrw_start()
{
		if /bin/mount -vf -o remount / | /bin/grep "\(.*rw.*\)"
		then
			/bin/mount -n -o remount,rw / >/dev/null 2>&1
			if [ ${?} -ne 0 ]
				then
				echo "Root filesystem could not be mounted read/write :("
				exit 1
			fi
		fi
}

rootrw_stop()
{
		echo "Unmounting all non-unmounted submounts ..."
		/usr/bin/awk 'NF && $1!~/^#/ && $2!~/^\/(|proc|sys|dev)$/ {print $2}' /proc/mounts | while read mp
		do
			echo "Unmounting: ${mp}"
			/bin/umount -rdf ${mp}
		done

		/bin/mount -n -o remount,ro /
		/bin/sync
		exit 0
}

mountroot_start()
{
		/bin/rm /etc/mtab
		if ! /bin/echo -n "" >> /etc/mtab
		then
			echo "Skipping /etc/mtab initialization (ro root?)"
			exit 0
		fi
		# Add the entry for / to mtab
		/bin/mount -f /

		# Don't list root more than once
		/bin/grep -v " / " /proc/mounts >>/etc/mtab
		# Now make sure /etc/mtab have additional info (gid, etc) in there

		# debian doesn't based on GNU, so we must do it a little different.
		# without GNU-tools, like uniq, sort or awk. i hope sed supports extended
		# regexp on debian. because it isn't posix-conform.
		/usr/bin/awk 'NF && $1!~/^#/ {print $2}' /etc/fstab /etc/mtab | /usr/bin/sort | /usr/bin/uniq -d | while read mp
		do
			echo "Mounting ${mp} rw ..."
			/bin/mount -f -o remount "${mp}"
		done

		# Remove stale backups
		/bin/rm -f /etc/mtab~ /etc/mtab~~
		# Return Happily., or sulogin will be executed.
		exit 0
}
