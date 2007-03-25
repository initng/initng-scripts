# NAME:
# DESCRIPTION:
# WWW:

dm_dir="/dev/mapper"
dm_file="${dm_dir}/control"

setup()
{
	iregister -s "system/mountroot/dmsetup" service
	iregister -s "system/mountroot/lvm" service
	iregister -s "system/mountroot/evms" service
	iregister -s "system/mountroot/check" service
	iregister -s "system/mountroot/rootrw" service
	iregister -s "system/mountroot" service

	iset -s "system/mountroot/dmsetup" need = "system/initial system/modules/dm-mod"
	iset -s "system/mountroot/lvm" need = "system/initial system/modules/lvm system/modules/lvm-mod system/mountroot/dmsetup"
	iset -s "system/mountroot/evms" need = "system/initial"
	iset -s "system/mountroot/check" need = "system/initial"
	iset -s "system/mountroot/check" use = "system/hdparm system/mountroot/evms system/mountroot/lvm system/mountroot/dmsetup"
	iset -s "system/mountroot/check" critical
	iset -s "system/mountroot/check" never_kill
	iset -s "system/mountroot/rootrw" need = "system/initial system/mountroot/check"
	iset -s "system/mountroot/rootrw" use = "system/mountroot/evms system/mountroot/lvm system/mountroot/dmsetup"
	iset -s "system/mountroot/rootrw" critical
	iset -s "system/mountroot" need = "system/initial system/mountroot/rootrw"

	iexec -s "system/mountroot/dmsetup" start = "@/sbin/dmsetup@ mknodes"
	iexec -s "system/mountroot/lvm" start = lvm_start
	iexec -s "system/mountroot/evms" start = "@/sbin/evms_activate@"
	iexec -s "system/mountroot/check" start = check_start
	iexec -s "system/mountroot/rootrw" start = rootrw_start
	iexec -s "system/mountroot/rootrw" stop = rootrw_stop
	iexec -s "system/mountroot" start = mountroot_start

	idone -s "system/mountroot/dmsetup"
	idone -s "system/mountroot/lvm"
	idone -s "system/mountroot/evms"
	idone -s "system/mountroot/check"
	idone -s "system/mountroot/rootrw"
	idone -s "system/mountroot"
}

lvm_start()
{
		@mknod@ --mode=600 /dev/lvm c 109 0
		if [ ! -f /dev/.devfsd ]
		then
			major=`@grep@ "[0-9] misc$" /proc/devices | @sed@ 's/[ ]\+misc//'`
			minor=`@grep@ "[0-9] device-mapper$" /proc/misc | @sed@ 's/[ ]\+device-mapper//'`
			[ -d ${dm_dir} ] || @mkdir@ --mode=755 ${dm_dir}
			[ -c ${dm_file} -o -z "${major}" -o -z "${minor}" ] || @mknod@ --mode=600 ${dm_file} c ${major} ${minor}
		fi
		@/sbin/vgscan@ --ignorelockingfailure --mknodes
		@/sbin/vgchange@ --ignorelockingfailure -a y
}

check_start()
{
		[ -f /fastboot ] && exit 0

		retval=0

		if [ -f /forcefsck ]
		then
			echo "Checking root filesystem (full fsck forced)"
			@mount@ -n -o remount,ro /
			@logsave@ /dev/null @fsck@ -C -a -f /
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
			# @sed@ -ne "'/^#/!s/^$s*$D$d\/$d$D$d$D$d$D$d\($D\)$s/\1/p'" /etc/fstab
				#Borrowed from standard init.
			exec 9<&0 </etc/fstab
			rootcheck=no
			while read DEV MTPT FSTYPE OPTS DUMP PASS JUNK
			do
				case "${DEV}" in
				""|\#*)
					continue;
					;;
				esac
				[ "${MTPT}" != "/" ] && continue
				[ "${PASS}" != 0 -a "${PASS}" != "" ] && rootcheck=yes
				[ "${FSTYPE}" = "nfs" -o "${FSTYPE}" = "nfs4" ] && rootcheck=no
				break;
			done
			exec 0<&9 9<&-

			if [ "${rootcheck}" = yes ]
			then
				echo "Checking root filesystem ..."
				@mount@ -n -o remount,ro /
				@logsave@ /dev/null @fsck@ -C -T -a /
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
				#sleep 5
				echo "Will now restart"
				@/sbin/ngc@ -6
			fi
		fi
		exit 0
}

rootrw_start()
{
		if @mount@ -vnf -o remount / | @grep@ "\(.*rw.*\)"
		then
			@mount@ -n -o remount,rw / >/dev/null 2>&1
#ifd pingwinek
			# code 32 means 'not implemented', we got it on livecd using
			# unionfs combined with squashfs
			if [ ${?} -ne 0 -a ${?} -ne 32 ]
#elsed
			if [ ${?} -ne 0 ]
#endd
				then
				echo "Root filesystem could not be mounted read/write :("
				exit 1
			fi
		fi
}

rootrw_stop()
{
		@mount@ -n -o remount,ro /
		@sync@
		exit 0
}

mountroot_start()
{
		@rm@ /etc/mtab
		if ! /bin/echo -n "" >> /etc/mtab
		then
			echo "Skipping /etc/mtab initialization (ro root?)"
			exit 0
		fi
		# Add the entry for / to mtab
		@mount@ -f /

		# Don't list root more than once
		@grep@ -v " / " /proc/mounts >>/etc/mtab

		# Remove stale backups
		@rm@ -f /etc/mtab~ /etc/mtab~~

		# Return Happily., or sulogin will be executed.
		exit 0
}
