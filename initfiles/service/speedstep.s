# SERVICE: service/speedstep
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/bootmisc \
	        	    system/modules/cpufreq_ondemand \
			    system/modules/cpufreq_userspace \
			    system/modules/cpufreq_stats \
			    system/modules/cpufreq_conservative \
			    system/modules/cpufreq_powersave \
			    system/modules/speedstep_centrino
		iset use = system/modules system/coldplug
		iexec start
		iexec stop
	idone
}

start()
{
	@cat@ /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor >/tmp/origgovanor
	echo ondemand >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
}

stop()
{
	@cat@ /tmp/origgovanor >/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
}
