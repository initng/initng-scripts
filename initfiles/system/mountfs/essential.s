# SERVICE: system/mountfs/essential
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial/mountvirtfs system/mountroot \
		            system/checkfs
		iset use = system/sraid system/hdparm system/selinux/relabel
		iset critical
		iset never_kill
		iexec start
		iexec stop
	idone
}

start() {
	for mp in /tmp /usr /var /srv /opt; do
		@mount@ -v "${mp}" 2>/dev/null &
	done
	wait
	exit 0
}

stop() {
	echo "Sending all processes the TERM signal ..."
	@killalli5:killall5@ -15
	sleep 3
	echo "Sending all processes the KILL signal ..."
	@killalli5:killall5@ -9
	sleep 1

	MPS="$(
		while read d mp d; do
			echo ${mp}
		done < /proc/mounts | @sort@ -r
	)"

	echo "${MPS}" | while read mp; do
		case "${mp}" in
		/proc|/sys|/dev|/) ;;
		*)
			@umount@ -r -d -f "${mp}"
			;;
		esac
	done
	exit 0
}
