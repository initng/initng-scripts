# NAME: acpid
# DESCRIPTION: Advanced Configuration and Power Interface daemon
# WWW: http://acpid.sourceforge.net

MODULES="all"
#ifd debian
	source /etc/default/acpid
#endd

setup()
{
	iregister -s "daemon/acpid/modules" service
	iregister -s "daemon/acpid" daemon

	iset -s "daemon/acpid/modules" need = "system/bootmisc"
	iset -s "daemon/acpid" need = "system/bootmisc daemon/acpid/modules"
	iset -s "daemon/acpid" use = "system/discover system/coldplug"

	iexec -s "daemon/acpid/modules" start = modules_start
	iexec -s "daemon/acpid" daemon = "@/usr/sbin/acpid@ -f -c /etc/acpi/events ${OPTIONS}"

	idone -s "daemon/acpid/modules"
	idone -s "daemon/acpid"
}

modules_start()
{
	# Check for ACPI support on kernel side
	[ -d /proc/acpi ] || exit 0

	LIST=`/sbin/lsmod | @sed@ -ne '2,$p'`
		
	# Get list of available modules
	LOC="/lib/modules/`uname -r`/kernel/drivers/acpi"
	if [ -d ${LOC} ]
	then
		# we doesn't support linux 2.4, so we need to look for .ko
		MODAVAIL=`@find@ ${LOC} -type f -name "*.ko" -printf "%f\n" | @sed@ 's/\.ko$//'`
	else
		MODAVAIL=""
	fi
	
	# If no modules is set to load.
	[ "${MODULES}" = "all" ] && MODULES="${MODAVAIL}"
	
	if [ -n "${MODULES}" ]
	then
		for mod in ${MODULES}
		do
			echo ${MODAVAIL} | @grep@ -q -w "${mod}" || continue
			echo ${LIST} | @grep@ -q -w "${mod}" || @/sbin/modprobe@ -q ${mod} >/dev/null 2>&1
		done
	fi
	exit 0
}
