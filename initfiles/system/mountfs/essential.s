# SERVICE: system/mountfs/essential
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
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

start()
{
	for mp in /tmp /usr /var /srv /opt; do
		@grep@ -q "[[:space:]]${mp}[[:space:]]" /etc/fstab &&
		@mount@ -v "${mp}" &
	done
	wait
	exit 0
}

stop()
{
	echo "Sending all processes the TERM signal ..."
	@killalli5:killall5@ -15
	sleep 3
	echo "Sending all processes the KILL signal ..."
	@killalli5:killall5@ -9
	sleep 1

	FILES="`@sed@ 's:^\S*\s*::' /etc/mtab | @sort@ -r`"

	echo "${FILES}" | while read mp drop; do
		case "${mp}" in
			/proc|/sys|/dev|/) ;;
			*)
				@mountpoint@ -q "${mp}" && {
					@umount@ -r -d -f "${mp}" ||
					echo "WARNING, failed to umount ${mp}"
				}
				;;
		esac
	done
	exit 0
}
