#!/sbin/runiscript


MODULES=all
OPTIONS=
#ifd debian
source /etc/default/acpid
#endd

setup()
{
	if [ "$SERVICE" == "acpid/modules" ]
	then
    	iregister service
    	iset need = bootmisc
		iexec start = load_modules
    	idone
		exit 0
	fi
	
	iregister daemon
	iset need = "bootmisc acpid/modules"
	iset use = "discover coldplug"
	iset exec daemon = "@/usr/sbin/acpid@ -f -c /etc/acpi/events ${OPTIONS}"
	idone
}

load_modules()
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
				echo ${LIST} | @grep@ -q -w "${mod}" || @/sbin/modprobe@ -q ${mod}
			done
		fi
		exit 0
}
