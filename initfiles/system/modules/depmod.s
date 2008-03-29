# SERVICE: system/modules/depmod
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial system/mountroot
		iexec start
	idone
}

start() {
	# Should not fail if kernel do not have module
	# support compiled in ...
	[ -f /proc/modules ] || exit 0

	# Here we should fail, as a modular kernel do need
	# depmod command ...
	if [ ! -e /lib/modules/`@uname@ -r`/modules.dep ]; then
#ifd gentoo
		@/sbin/modules-update@
#elsed
		if [ ! -x @/sbin/depmod@ ]; then
			echo "ERROR:  system is missing @/sbin/depmod@ !"
			exit 1
		fi
		@/sbin/depmod@
#endd
		exit 0
	else
		echo "Found modules.dep, skipping depmod ..."
	fi

	# if /etc/modules.d is newer then /etc/modules.conf
	if [ /etc/modules.d -nt /etc/modules.conf ]; then
		echo "Calculating module dependencies ..."
		if [ ! -x @/sbin/depmod@ ]
		then
			echo "ERROR:  system is missing @/sbin/depmod@ !"
			exit 1
		fi
#ifd gentoo
		@/sbin/modules-update@
#elsed
		@/sbin/depmod@
#endd
		exit 0
	else
		echo "Module dependencies up to date ..."
	fi

	wait
#ifd debian
	[ -x @/sbin/lrm-manager@ ] && @/sbin/lrm-manager@ --quick
#endd
	exit 0
}
