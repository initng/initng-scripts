# SERVICE: system/modules
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial system/mountroot \
		            system/modules/loop
		iset use = system/modules/depmod
		iexec start
	idone
}

start() {
	load_modules() {
		[ -r "${1}" ] || return 1
		@grep@ -v "^#" "${1}" | @grep@ -v "^$" | while read MODULE MODARGS; do
			{
				echo "Loading module \"${MODULE}\" ..."
				@/sbin/modprobe@ -q ${MODULE} ${MODARGS}
			} &
		done
	}

	# GENTOO: Don't probe kernel version, initng, requires 2.6 anyway
#ifd gentoo
	load_modules /etc/modules.autoload.d/kernel-2.6
	load_modules /etc/modules
#elsed lfs
	load_modules /etc/sysconfig/modules
#elsed enlisy
	load_modules /etc/conf.d/modules
#elsed
	load_modules /etc/modules
#endd
	wait
	exit 0  # Bad things happen if we fail
}
