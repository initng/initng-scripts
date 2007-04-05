# NAME:
# DESCRIPTION:
# WWW:

#ifd suse
CONFIG="/etc/sysconfig/powersave"
source /etc/sysconfig/powersave/common
source /etc/sysconfig/powersave/cpufreq
#elsed
CONFIG="/etc/powersave"
source /etc/powersave/common
source /etc/powersave/cpufreq
#endd
LOGGER="@echo@"
SYSFS_PATH="/sys/devices/system/cpu/cpu0/cpufreq"

setup()
{
	ireg service daemon/powersaved/prepare
	iset need = system/bootmisc daemon/acpid
	iexec start = prepare_start
	idone

	ireg daemon daemon/powersaved
	iset need = system/bootmisc system/modules daemon/dbus daemon/hald \
	            daemon/powersaved/prepare daemon/acpid
	iset pid_file = "/var/run/powersaved.pid"
	iset forks
	iset exec daemon = "@/usr/sbin/powersaved@ -d -f /var/run/acpid.socket"
	idone
}

prepare_start()
{
        CPUFREQ_MODULES="speedstep_centrino speedstep_ich powernow_k8 powernow_k7 powernow_k6 longrun longhaul acpi_cpufreq"
        CPUFREQ_MODULES_GREP="^speedstep_centrino\|^speedstep_ich\|^powernow_k8\|^powernow_k7\|^powernow_k6\|^longrun\|^longhaul\|^acpi_cpufreq"

       	###### load CPUFREQ modules ############
       	# module specfied in sysconfig.cpufreq?
       	if [ "$CPUFREQD_MODULE" != "off" ]; then
               	# test for already loaded modules
               	ALREADY_LOADED_MODS=`@grep@ $CPUFREQ_MODULES_GREP /proc/modules`
               	if [ "$CPUFREQD_MODULE" ]; then
                       	@/sbin/modprobe@ -q $CPUFREQD_MODULE $CPUFREQD_MODULE_OPTS >/dev/null 2>&1
                       	RETVAL=$?
               	# try to load one of the modules we know
               	elif [ -z "$ALREADY_LOADED_MODS" ] ; then
                       	for MODULE in $CPUFREQ_MODULES; do
                               	$LOGGER "Loading $MODULE"
                               	@/sbin/modprobe@ $MODULE >/dev/null 2>&1
                               	RETVAL=$?
                               	[ "$RETVAL" = 0 ] && break
                       	done
                       	# skip if no module could be loaded!
                       	if [ "$RETVAL" != 0 ]; then
                               	$LOGGER "CPU frequency scaling is not supported by your processor."
                               	$LOGGER "Enter 'CPUFREQD_MODULE=off' in $CONFIG/cpufreq to avoid this warning."
                       	else
                               	$LOGGER "Enter '$MODULE' into CPUFREQD_MODULE in $CONFIG/cpufreq."
                               	$LOGGER "This will speed up starting powersaved and avoid unnecessary warnings in syslog."
               		fi
               	fi

		###### load scaling governors ##########
		if [ ! -r $SYSFS_PATH ];then
       			$LOGGER Cannot load cpufreq governors - No cpufreq driver available
       			exit 1
		fi

		read govs < $SYSFS_PATH/scaling_available_governors
		case "$govs" in
			*powersave*)
				;;
			*)
				@/sbin/modprobe@ -q cpufreq_powersave >/dev/null 2>&1
				[ $? != 0 ] && $LOGGER powersave cpufreq governor could not be loaded
				;;
		esac
		case "$govs" in
			*performance*)
				;;
			*)
				@/sbin/modprobe@ -q cpufreq_performance >/dev/null 2>&1
				[ $? != 0 ] && $LOGGER perfromance cpufreq governor could not be loaded
				;;
		esac
		case "$govs" in
			*userspace*)
				;;
			*)
				@/sbin/modprobe@ -q cpufreq_userspace >/dev/null 2>&1
				[ $? != 0 ] && $LOGGER userspace cpufreq governor could not be loaded
				;;
		esac
		case "$govs" in
			*ondemand*)
				;;
			*)
				@/sbin/modprobe@ -q cpufreq_ondemand >/dev/null 2>&1
				[ $? != 0 ]&& $LOGGER ondemand cpufreq governor could not be loaded
				;;
		esac
	fi

	exit 0
}
