# SERVICE: system/mountroot/dmsetup
# NAME:
# DESCRIPTION:
# WWW:

dm_dir="/dev/mapper"
dm_file="${dm_dir}/control"

setup()
{
	iregister service
		iset need = system/initial system/modules/dm-mod
		iset exec start = "@/sbin/dmsetup@ mknodes"
	idone
}
