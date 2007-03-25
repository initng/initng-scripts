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
	iregister -s "service/lm-sensors/modules" service
	iregister -s "service/lm-sensors" service

	iset -s "service/lm-sensors/modules" need = "system/bootmisc system/modules/i2c-core"
	iset -s "service/lm-sensors/modules" use = "system/modules"
	iset -s "service/lm-sensors/modules" stdall = /dev/null
	iset -s "service/lm-sensors" need = "system/bootmisc service/lm-sensors/modules"
	iset -s "service/lm-sensors" use = "system/modules"
	iset -s "service/lm-sensors" stdout = /dev/null

	iexec -s "service/lm-sensors/modules" start = modules_start
	iexec -s "service/lm-sensors/modules" stop = modules_stop
	iexec -s "service/lm-sensors" start = lm-sensors_start

	idone -s "service/lm-sensors/modules"
	idone -s "service/lm-sensors"
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

lm-sensors_start()
{
		# set alarm values on the sensor chip(s)
		@/usr/bin/sensors@ -s
		# clear out any alarms that may be present
		@/usr/bin/sensors@
}
