# SERVICE: system/checkfs
# NAME:
# DESCRIPTION:
# WWW:

#ifd debian
FSCK_LOGFILE="/var/log/fsck/checkfs"
[ -f /etc/default/rcS ] && . /etc/default/rcS
#endd

setup() {
	iregister service
		iset need = system/initial system/mountroot
		iset use = system/sraid system/hdparm
		iset never_kill
		iexec start
	idone
}

start() {
#ifd debian
	handle_failed_fsck() {
		echo "File system check failed."
		echo "A log is being saved in ${FSCK_LOGFILE} if that location is writable. Please repair the file system manually."
		echo "A maintenance shell will now be started."
		echo "CONTROL-D will terminate this shell and resume system boot."
		# Start a single user shell on the console
		exit 1
	}

	[ "${FSCKFIX}" ] || FSCKFIX=no

	# See if we're on AC Power
	# If not, we're not gonna run our check
	if [ -x "@on_ac_power@" ]; then
		@on_ac_power@ >/dev/null 2>&1
		[ ${?} -eq 1 ] && BAT=yes
	fi

	#
	# Check the rest of the file systems.
	#
	if ! [ -f /fastboot -a -n "${BAT}" -a "${FSCKTYPES}" = "none" ]; then
		force=""
		[ -f /forcefsck ] && force="-f"
		fix="-a"
		[ "${FSCKFIX}" = yes ] && fix="-y"
		spinner="-C"
		[ "${TERM}" = dumb -o "${TERM}" = network -o "${TERM}" = unknown -o -z "${TERM}" ] && spinner=""
		[ "$(uname -m)" = s390 ] && spinner=""  # This should go away
		FSCKTYPES_OPT=""
		[ "${FSCKTYPES}" ] && FSCKTYPES_OPT="-t ${FSCKTYPES}"

		if [ "${VERBOSE}" = no ]; then
			echo "Checking file systems"
			@/sbin/logsave@ -s ${FSCK_LOGFILE} @fsck@ ${spinner} -T -R -A ${fix} ${force} ${FSCKTYPES_OPT}
			FSCKCODE=${?}

			if [ ${FSCKCODE} -gt 1 ]; then
				echo 1 "code ${FSCKCODE}"
				handle_failed_fsck
			fi
		else
			if [ "${FSCKTYPES}" ]; then
				echo "Will now check all file systems of types ${FSCKTYPES}"
			else
				echo "Will now check all file systems"
			fi

			@/sbin/logsave@ -s ${FSCK_LOGFILE} @fsck@ ${spinner} -V -R -A ${fix} ${force} ${FSCKTYPES_OPT}
			FSCKCODE=${?}

			if [ ${FSCKCODE} -gt 1 ]; then
				handle_failed_fsck
			else
				echo "Done checking file systems."
				echo "A log is being saved in ${FSCK_LOGFILE} if that location is writable."
			fi
		fi
	fi

	@rm@ -f /fastboot /forcefsck
#elsed
	if [ -f /fastboot ]; then
		@rm@ -f /fastboot
	else
		if [ -f /forcefsck ]; then
			echo "A full fsck has been forced"
			@/sbin/logsave@ /dev/null @fsck@ -C -R -A -a -f || echo "fsck error: ${?}" >&2
			@/bin/rm@ -f /forcefsck
		else
			@/sbin/logsave@ /dev/null @fsck@ -C -T -R -A -a || echo "fsck error: ${?}" >&2
		fi
	fi
#endd

	exit 0
}
