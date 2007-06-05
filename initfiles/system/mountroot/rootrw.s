# SERVICE: system/mountroot/rootrw
# NAME:
# DESCRIPTION:
# WWW:

dm_dir="/dev/mapper"
dm_file="${dm_dir}/control"

setup()
{
	iregister service
		iset need = system/initial system/mountroot/check
		iset use = system/mountroot/evms system/mountroot/lvm \
			   system/mountroot/dmsetup
		iset critical
		iexec start
		iexec stop
	idone
}

start()
{
	@mount@ -n -o remount,rw / >/dev/null 2>&1
#ifd pingwinek
	# code 32 means 'not implemented', we got it on livecd using
	# unionfs combined with squashfs
	if [ ${?} -ne 0 -a ${?} -ne 32 ]; then
#elsed
	if [ ${?} -ne 0 ]; then
#endd
		echo "Root filesystem could not be mounted read/write :("
		exit 1
	fi
}

stop()
{
	@mount@ -n -o remount,ro /
	@sync@
	exit 0
}
