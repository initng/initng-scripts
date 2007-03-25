# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister -s "system/modules/depmod" service
	iregister -s "system/modules/dm-mod" service
	iregister -s "system/modules/*" service
	iregister -s "system/modules" service

	iset -s "system/modules/depmod" need = "system/initial system/mountroot"
	iset -s "system/modules/dm-mod" need = "system/initial"
	iset -s "system/modules/dm-mod" stdall = /dev/null
	iset -s "system/modules/*" need = "system/initial"
	iset -s "system/modules/*" use = "system/modules/depmod"
	iset -s "system/modules/*" stdall = /dev/null
	iset -s "system/modules" need = "system/initial system/mountroot system/modules/loop"
	iset -s "system/modules" use = "system/modules/depmod"

	iexec -s "system/modules/depmod" start = depmod_start
	iexec -s "system/modules/dm-mod" start = dm-mod_start
	iexec -s "system/modules/dm-mod" stop = dm-mod_stop
	iexec -s "system/modules/*" start = modules_any_start
	iexec -s "system/modules/*" stop = modules_any_stop
	iexec -s "system/modules" start = modules_start

	idone -s "system/modules/depmod"
	idone -s "system/modules/dm-mod"
	idone -s "system/modules/*"
	idone -s "system/modules"
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

dm-mod_start()
{
		@/sbin/modprobe@ -q dm-mod
		exit 0
}

dm-mod_stop()
{
		@/sbin/modprobe@ -q -r dm-mod
		exit 0
}

modules_any_start()
{
		@/sbin/modprobe@ -q ${NAME}
		exit 0
}

modules_any_stop()
{
		@/sbin/modprobe@ -q -r ${NAME}
		exit 0
}

modules_start()
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
#elsed
		load_modules /etc/modules
#endd
		wait
		exit 0  # Bad things happen if we fail
}
