# SERVICE: system/mountroot/lvm
# NAME:
# DESCRIPTION:
# WWW:

dm_dir="/dev/mapper"
dm_file="${dm_dir}/control"

setup() {
	iregister service
		iset need = system/initial system/modules/lvm \
			    system/modules/lvm-mod system/mountroot/dmsetup
		iexec start
	idone
}

start() {
	config='global { locking_dir = "/dev/.lvm" }'
	@mknod@ --mode=600 /dev/lvm c 109 0
	if [ ! -f /dev/.devfsd ]; then
		major=`@grep@ "[0-9] misc$" /proc/devices | @sed@ 's/[ ]\+misc//'`
		minor=`@grep@ "[0-9] device-mapper$" /proc/misc | @sed@ 's/[ ]\+device-mapper//'`
		[ -d ${dm_dir} ] || @mkdir@ --mode=755 ${dm_dir}
		[ -c ${dm_file} -o -z "${major}" -o -z "${minor}" ] || @mknod@ --mode=600 ${dm_file} c ${major} ${minor}
	fi
	@/sbin/vgscan@ --config "${config}" --mknodes
	@/sbin/vgchange@ --config "${config}" -a y
}
