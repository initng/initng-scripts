#!/sbin/runiscript

setup()
{
    iregister service
    iset need = "bootmisc modules/cpufreq_ondemand modules/cpufreq_userspace modules/cpufreq_stats modules/cpufreq_powersave modules/cpufreq_conservative modules/speedstep_centrino"
	iset use = "modules"
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
