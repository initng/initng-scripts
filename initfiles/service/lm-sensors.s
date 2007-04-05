# NAME:
# DESCRIPTION:
# WWW:

#ifd fedora suse mandriva
source /etc/sysconfig/lm_sensors
#elsed
source /etc/conf.d/lm_sensors
#endd

setup()
{
	ireg service service/lm-sensors/modules
	iset need = system/bootmisc system/modules/i2c-core
	iset use = system/modules
	iset stdall = "/dev/null"
	iexec start = modules_start
	iexec stop = modules_stop
	idone

	ireg service service/lm-sensors
	iset need = system/bootmisc service/lm-sensors/modules
	iset use = system/modules
	iset stdout = "/dev/null"
	iexec start
	idone
}

modules_start()
{
	i=0
	while true
	do
		eval module=\"\${MODULE_${i}}\"
		eval module_args=\"\${MODULE_${i}_ARGS}\"
		[ -z "${module}" ] && break
		if `@modprobe@ -l | @grep@ -q "${module}.ko"`
		then
			@/sbin/modprobe@ "${module}" ${module_args}
		fi
		i=$((i+1))
	done
}

modules_stop()
{
	i=0
	while true
	do
		eval module=\"\${MODULE_${i}}\"
		[ -z "${module}" ] && break
		@/sbin/rmmod@ "${module}"
		i=$((i+1))
	done
}

start()
{
	# set alarm values on the sensor chip(s)
	@/usr/bin/sensors@ -s
	# clear out any alarms that may be present
	@/usr/bin/sensors@
}
