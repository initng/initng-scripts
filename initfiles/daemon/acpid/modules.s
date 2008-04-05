# SERVICE: daemon/acpid/modules
# NAME: acpid
# DESCRIPTION: Advanced Configuration and Power Interface daemon
# WWW: http://acpid.sourceforge.net

MODULES="all"
#ifd debian
[ -f /etc/default/acpid ] && . /etc/default/acpid
#endd

setup() {
	iregister service
		iset need = system/bootmisc
		iexec start
	idone
}

start() {
	# Check for ACPI support on kernel side
	[ -d /proc/acpi ] || exit 0

	LIST=`/sbin/lsmod | @sed@ -ne '2,$p'`

	# Get list of available modules
	LOC="/lib/modules/`uname -r`/kernel/drivers/acpi"
	if [ -d ${LOC} ]; then
		# we doesn't support linux 2.4, so we need to look for .ko
		MODAVAIL=`@find@ ${LOC} -type f -name "*.ko" -or -name "*.ko.gz" -printf "%f\n" | @sed@ 's/\.ko.*$//'`
	else
		MODAVAIL=""
	fi

	# If no modules is set to load.
	[ "${MODULES}" = "all" ] && MODULES="${MODAVAIL}"

	if [ -n "${MODULES}" ]; then
		for mod in ${MODULES}; do
			echo ${MODAVAIL} | @grep@ -q -w "${mod}" || continue
			echo ${LIST} | @grep@ -q -w "${mod}" ||
				@/sbin/modprobe@ -q ${mod} >/dev/null 2>&1
		done
	fi
	exit 0
}
