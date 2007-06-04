# SERVICE: service/lm-sensors
# NAME:
# DESCRIPTION:
# WWW:

#ifd fedora suse mandriva
[ -f /etc/sysconfig/lm_sensors ] && . /etc/sysconfig/lm_sensors
#elsed
[ -f /etc/conf.d/lm_sensors ] && . /etc/conf.d/lm_sensors
#endd

setup()
{
	iregister service
		iset need = system/bootmisc service/lm-sensors/modules
		iset use = system/modules
		iset stdout = "/dev/null"
		iexec start
	idone
}

start()
{
	# set alarm values on the sensor chip(s)
	@/usr/bin/sensors@ -s
	# clear out any alarms that may be present
	@/usr/bin/sensors@
}
