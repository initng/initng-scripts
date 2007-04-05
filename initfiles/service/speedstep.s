# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service service/speedstep
	iset need = system/bootmisc \
	            system/modules/cpufreq_{ondemand,userspace,stats,powersave,conservative} \
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
