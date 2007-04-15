# NAME: acpid
# DESCRIPTION: Advanced Configuration and Power Interface daemon
# WWW: http://acpid.sourceforge.net

MODULES="all"
#ifd debian
[ -f /etc/default/acpid ] && . /etc/default/acpid
#endd

setup()
{
	ireg service daemon/acpid/modules && {
		iset need = system/bootmisc
		iexec start = modules_start
		return 0
	}

	ireg daemon daemon/acpid && {
		iset need = system/bootmisc daemon/acpid/modules
		iset use = system/discover system/coldplug
		iset exec daemon = "@/usr/sbin/acpid@ -f -c /etc/acpi/events ${OPTIONS}"
	}
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
