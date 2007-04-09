# NAME:
# DESCRIPTION:
# WWW:

dm_dir="/dev/mapper"
dm_file="${dm_dir}/control"

setup()
{
	ireg service system/mountroot/dmsetup
	iset need = system/initial system/modules/dm-mod
	iset exec start = "@/sbin/dmsetup@ mknodes"
	idone

	ireg service system/mountroot/lvm
	iset need = system/initial system/modules/lvm system/modules/lvm-mod \
	            system/mountroot/dmsetup
	iexec start = lvm_start
	idone

	ireg service system/mountroot/evms
	iset need = system/initial
	iset exec start = "@/sbin/evms_activate@"
	idone

 	ireg service system/mountroot/check
	iset need = system/initial
	iset use = system/hdparm system/mountroot/evms system/mountroot/lvm \
	           system/mountroot/dmsetup
	iset critical
	iset never_kill
	iexec start = check_start
	idone

	ireg service system/mountroot/rootrw
	iset need = system/initial system/mountroot/check
	iset use = system/mountroot/evms system/mountroot/lvm \
	           system/mountroot/dmsetup
	iset critical
	iexec start = rootrw_start
	iexec stop = rootrw_stop
	idone

	ireg service system/mountroot
	iset need = system/initial system/mountroot/rootrw
	iexec start = mountroot_start
	idone
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
}

rootrw_stop()
{
	@mount@ -n -o remount,ro /
	@sync@
	exit 0
}

mountroot_start()
{
	if ! : > /etc/mtab
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
