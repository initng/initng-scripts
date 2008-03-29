# SERVICE: system/mountroot/evms
# NAME:
# DESCRIPTION:
# WWW:

dm_dir="/dev/mapper"
dm_file="${dm_dir}/control"

setup() {
	iregister service
		iset need = system/initial
		iset exec start = "@/sbin/evms_activate@"
	idone
}
