# SERVICE: system/sraid
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial system/mountroot
		iset critical
		iexec start
	idone
}

start() {
	# You need a properly configured /etc/raidtab for raidtools usage or a
	# properly configured /etc/mdadm.conf for mdadm usage. Devices in
	# /etc/mdadm.conf are initialized first, so any duplicate devices in
	# /etc/raidtab will not get initialized.
	[ -f /proc/mdstat ] || exit 0
	retval=0

	# If /etc/mdadm.conf exists, grab all the RAID devices from it
	if [ -f /etc/mdadm.conf ]; then
		while read a b drop; do
			[ "${a}" = "ARRAY" ] &&
			mdadm_devices="${mdadm_devices} ${b}"
		done < /etc/mdadm.conf
	fi

	# If /etc/raidtab exists, grab all the RAID devices from it
	if [ -f /etc/raidtab ]; then
		while read a b drop; do
			[ "${a}" = "raiddev" ] &&
			raidtools_devices="${raidtools_devices} ${b}"
		done < /etc/raidtab
	fi

	echo "Starting up RAID devices ... "
	rc=0
	for i in ${mdadm_devices}; do
		raiddev=${i##*/}
		raidstat=`@egrep@ "^${raiddev} : active" /proc/mdstat`
		if [ -z "${raidstat}" ]; then
			# First scan the /etc/fstab for the "noauto"-flag
			# for this device. If found, skip the initialization
			# for it to avoid dropping to a shell on errors.
			# If not, try raidstart...if that fails then
			# fall back to raidadd, raidrun.  If that
			# also fails, then we drop to a shell
			retval=1
			noauto=0
			@egrep@ -q "${i}\s+\S+\s+\S+\s+(.*,)?noauto(,.*)?$" /etc/fstab && noauto=1

			echo "  Trying ${raiddev}..."
			raiddev=""

			if [ "${noauto}" -gt 0 ]; then
				retval=0
				raiddev=" (skipped)"
			fi

			if [ "${retval}" -gt 0 -a -x "@/sbin/mdadm@" ]; then
				@/sbin/mdadm@ -As "${i}" >/dev/null 2>&1
				retval=${?}
			fi
			echo "${raiddev}"

			if [ "${retval}" -gt 0 ]; then
				rc=1
				echo "Raid is up..."
			else
				echo "Problems initiating raid..."
			fi
		fi
	done

	for i in ${raidtools_devices}; do
		raiddev=${i##*/}
		raidstat=`@egrep@ "^${raiddev} : active" /proc/mdstat`
		if [ -z "${raidstat}" ]; then
			# First scan the /etc/fstab for the "noauto"-flag
			# for this device. If found, skip the initialization
			# for it to avoid dropping to a shell on errors.
			# If not, try raidstart...if that fails then
			# fall back to raidadd, raidrun.  If that
			# also fails, then we drop to a shell
			retval=1
			noauto=0
			@grep@ -q -r "${i}\s+\S+\s+\S+\s+(.*,)?noauto(,.*)?$" /etc/fstab && noauto=1

			echo "  Trying ${raiddev}..."
			raiddev=""

			if [ "${noauto}" -gt 0 ]; then
				retval=0
				raiddev=" (skipped)"
			fi

			if [ "${retval}" -gt 0 -a -x @/sbin/raidstart@ ]; then
				@/sbin/raidstart@ "${i}"
				retval=${?}
			fi

			if [ "${retval}" -gt 0 -a -x @/sbin/raid0run@ ]; then
				@/sbin/raid0run@ "${i}"
				retval=${?}
			fi

			if [ "${retval}" -gt 0 -a -x @/sbin/raidadd@ -a -x @/sbin/raidrun@ ]; then
				@/sbin/raidadd@ "${i}"
				@/sbin/raidrun@ "${i}"
				retval=${?}
			fi

			echo "${raiddev}"
			if [ "${retval}" -gt 0 ]; then
				rc=1
				echo "Raid is up ..."
			else
				echo "Problems with raid ..."
			fi
		fi
	done

	# A non-zero return means there were problems.
	if [ "${rc}" -gt 0 ]; then
		echo
		echo "An error occurred during the RAID startup"
		echo "Dropping you to a shell; the system will reboot"
		echo "when you leave the shell."
		echo
		echo
		exit 1
	fi
	exit ${retval}
}
