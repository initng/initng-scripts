# SERVICE; daemon/hddtemp
# NAME:
# DESCRIPTION:
# WWW:

DISKS="/dev/hd? /dev/sr? /dev/sg? /dev/sd?"
INTERFACE="0.0.0.0"
PORT="7634"
SEPARATOR="|"
SYSLOG="0"
RUN_DAEMON="yes"
#ifd debian
[ -f /etc/default/hddtemp ] && . /etc/default/hddtemp
#elsed
[ -f /etc/conf.d/hddtemp ] && . /etc/conf.d/hddtemp
#endd

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset forks
		iset pid_of = hddtemp
		iexec daemon
	idone
}

daemon()
{
	[ -n "${SYSLOG}" -a "${SYSLOG}" != "0" ] && SYSLOG_ARG="-S ${SYSLOG}"
	[ "${RUN_DAEMON}" = "true" -o "${RUN_DAEMON}" = "yes" ] && DAEMON_ARG="-d -l ${INTERFACE} -p ${PORT} -s ${SEPARATOR}"
	[ -x "@/usr/sbin/hddtemp@" ] || exit 1

	CDROMS_LIST="`@grep@ "^drive name:" /proc/sys/dev/cdrom/info 2>/dev/null | @sed@ -e 's/^drive name:	//g' -e 's/	/ \/dev\//g'`"
	CDROMS_LIST="${CDROMS_LIST} `@grep@ -sl '^ide-scsi ' /proc/ide/hd*/driver | @awk@ -F / '{ print "/dev/"$4 }'`"

	for disk in ${DISKS}
	do
		echo ${DISKS_NOPROBE} ${CDROMS_LIST} | @grep@ -wq ${disk} &&
			continue

		if @/usr/sbin/hddtemp@ -wn ${OPTIONS} ${disk} 2>/dev/null |
		   @grep@ -q '^[0-9]\+$'
		then
			DISKS_LIST="${DISKS_LIST} ${disk}"
		fi
	done

	[ -n "${DISKS_LIST}" -o -n "${DISKS_NOPROBE}" ] &&
		@/usr/sbin/hddtemp@ ${DAEMON_ARG} ${SYSLOG_ARG} ${OPTIONS} \
		                    ${DISKS_NOPROBE} ${DISKS_LIST}
}
