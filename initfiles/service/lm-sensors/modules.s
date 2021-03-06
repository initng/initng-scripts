# SERVICE: service/lm-sensors/modules
# NAME:
# DESCRIPTION:
# WWW:

#ifd fedora suse mandriva
[ -f /etc/sysconfig/lm_sensors ] && . /etc/sysconfig/lm_sensors
#elsed
[ -f /etc/conf.d/lm_sensors ] && . /etc/conf.d/lm_sensors
#endd

setup() {
	iregister service
		iset need = system/bootmisc system/modules/i2c-core
		iset use = system/modules
		iset stdall = "/dev/null"
		iexec start
		iexec stop
	idone
}

start() {
	i=0
	while true; do
		eval module=\"\${MODULE_${i}}"
		eval module_args=\"\${MODULE_${i}_ARGS}"
		[ -z "${module}" ] && break
		if @modprobe@ -l | @grep@ -q "${module}.ko"; then
			@/sbin/modprobe@ "${module}" ${module_args}
		fi
		i=$((i+1))
	done
}

stop() {
	i=0
	while true; do
		eval module=\"\${MODULE_${i}}"
		[ -z "${module}" ] && break
		@/sbin/rmmod@ "${module}"
		i=$((i+1))
	done
}
