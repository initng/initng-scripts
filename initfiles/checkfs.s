#!/sbin/runiscript

source /etc/default/rcS
FSCK_LOGFILE=/var/log/fsck/checkfs

setup()
{
	iregister service
	iset need = "initial mountroot"
	iset use = "sraid hdparm"
	iset never_kill
	iexec start
    idone
}

start()
{
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
		if [ -x "/usr/bin/on_ac_power" ]
		then
			/usr/bin/on_ac_power >/dev/null 2>&1
			[ ${?} -eq 1 ] && BAT=yes
		fi

		#
		# Check the rest of the file systems.
		#
		if ! [ -f /fastboot -a -n "${BAT}" -a "${FSCKTYPES}" = "none" ]
		then
			force=""
			[ -f /forcefsck ] && force="-f"
			fix="-a"
			[ "${FSCKFIX}" = yes ] && fix="-y"
			spinner="-C"
			[ "${TERM}" = dumb -o "${TERM}" = network -o "${TERM}" = unknown -o -z "${TERM}" ] && spinner=""
			[ "$(uname -m)" = s390 ] && spinner=""  # This should go away
			FSCKTYPES_OPT=""
			[ "${FSCKTYPES}" ] && FSCKTYPES_OPT="-t ${FSCKTYPES}"

			if [ "${VERBOSE}" = no ]
			then
				echo "Checking file systems"
				/sbin/logsave -s ${FSCK_LOGFILE} /sbin/fsck ${spinner} -T -R -A ${fix} ${force} ${FSCKTYPES_OPT}
				FSCKCODE=${?}
				if [ ${FSCKCODE} -gt 1 ]
				then
					echo 1 "code ${FSCKCODE}"
					handle_failed_fsck
				fi
			else
				if [ "${FSCKTYPES}" ]
				then
					echo "Will now check all file systems of types ${FSCKTYPES}"
				else
					echo "Will now check all file systems"
				fi
				/sbin/logsave -s ${FSCK_LOGFILE} /sbin/fsck ${spinner} -V -R -A ${fix} ${force} ${FSCKTYPES_OPT}
				FSCKCODE=${?}
				if [ ${FSCKCODE} -gt 1 ]
				then
					handle_failed_fsck
				else
					echo "Done checking file systems."
					echo "A log is being saved in ${FSCK_LOGFILE} if that location is writable."
				fi
			fi
		fi

		/bin/rm -f /fastboot /forcefsck

		exit 0
}
