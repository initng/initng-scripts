# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service system/modules/depmod && {
		iset need = system/initial system/mountroot
		iexec start = depmod_start
		return 0
	}

	ireg service system/modules && {
		iset need = system/initial system/mountroot system/modules/loop
		iset use = system/modules/depmod
		iexec start
		return 0
	}

	# system/modules/*
	ireg service && {
		iset need = system/initial
		[ "${NAME}" = dm-mod ] || iset use = system/modules/depmod
		iset stdall = /dev/null
		iexec start = module_load
		iexec stop = module_unload
	}
}

depmod_start()
{
	# Should not fail if kernel do not have module
	# support compiled in ...
	[ -f /proc/modules ] || exit 0

	# Here we should fail, as a modular kernel do need
	# depmod command ...
	if [ ! -e /lib/modules/`@uname@ -r`/modules.dep ]
	then
#ifd gentoo
		@/sbin/modules-update@
#elsed
		if [ ! -x @/sbin/depmod@ ]
		then
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
	if [ /etc/modules.d -nt /etc/modules.conf ]
	then
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

module_load()
{
	@/sbin/modprobe@ -q ${NAME}
	exit 0
}

module_unload()
{
	@/sbin/modprobe@ -q -r ${NAME}
	exit 0
}

start()
{
	load_modules() {
		[ -r "${1}" ] || return 1
		@grep@ -v "^#" "${1}" | @grep@ -v "^$" | while read MODULE MODARGS
		do
			{
				echo "Loading module \"${MODULE}\" ..."
				@/sbin/modprobe@ -q ${MODULE} ${MODARGS}
			} &
		done
	}
	# GENTOO: Don't probe kernel version, initng, requires 2.6 anyway
#ifd gentoo
	load_modules /etc/modules.autoload.d/kernel-2.6
	load_modules /etc/modules
#elsed lfs
	load_modules /etc/sysconfig/modules
#elsed enlisy
	load_modules /etc/conf.d/modules
#elsed
	load_modules /etc/modules
#endd
	wait
	exit 0  # Bad things happen if we fail
}
