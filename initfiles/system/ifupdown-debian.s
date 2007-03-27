# NAME:
# DESCRIPTION:
# WWW:

RUN_DIR="/etc/network/run"
IFSTATE="/etc/network/run/ifstate"
source /etc/default/ifupdown

setup()
{
	iregister service
	iset      need = "system/bootmisc"
	iexec     start
	iexec     stop
	idone
}

start()
{
	[ -x "@/sbin/ifup@" -a -x "@/sbin/ifdown@" ] || exit 0

	MYNAME="${0##*/}"
	report() {
		echo "${MYNAME}: ${*}"
	}
	report_err() {
		report "Error: ${*}" >&2
	}

	myreadlink () {
		dest="${1%/}"
		extras=""

		while [ "${dest}" != "" ]
		do
			if [ -d "${dest}" ]
			then
				cd "${dest}"
				dest=`@/bin/pwd@`
				break
			fi

			if [ -L "${dest}" ]
			then
				d2=`readlink "${dest}"`
				if [ "${d2#/}" = "${d2}" ]
				then
					dest="${dest%/*}/${d2}"
				else
					dest="${d2}"
				fi
			fi

			while [ ! -e "${dest}" ]
			do
				extras="${dest##*/}/${extras}"
				[ "${extras%%/*}" = ".." ] && return 1
				destx="${dest%/*}"
				[ "${destx}" = "${dest}" ] && destx=""
				dest="${destx}"
			done
		done
		dest="${dest}/${extras}"
		echo "${dest%/}"
	}

	# if /etc/network/run is a symlink to a directory that doesn't exist,
	# create it.

	if [ -L "${RUN_DIR}" -a ! -d "${RUN_DIR}" ]
	then
		runmkdir="`myreadlink "${RUN_DIR}"`"
		if [ ! "${runmkdir}" ]
		then
			echo "failed."
			report_err "Cannot create target of /etc/network/run"
			exit 1
		fi
		if ! @mkdir@ -p "${runmkdir}"
		then
			echo "failed."
			report_err "Failure creating directory ${runmkdir}"
			exit 1
		fi
	fi

	# Create the state file
	# Doing this also signals that ifupdown is available for use

	# We can always clean here, because debian's network script depends on this, it HAS to run first.
	if ! /bin/true >${IFSTATE}
	then
		echo "failed."
		report_err "Failure initializing ${IFSTATE}"
		exit 1
	fi

	exit 0
}

stop()
{
	echo -n "Cleaning up ifupdown..."

	if [ -f "${IFSTATE}" -a ! -L "${IFSTATE}" ]
	then
		@rm@ -f "${IFSTATE}"
		exit 0
	fi

	if [ -f "${IFSTATE}" ]
	then
		# This is kinda bad :(
		>${IFSTATE}
	fi
	exit 0
}
