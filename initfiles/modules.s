#!/sbin/runiscript

setup()
{
	
	if [ "$SERVICE" == "modules/depmod" ]
	then
		# modules/depmod
    	iregister service
		iset need = initial mountroot
		iexec depmod_start
		idone
		exit 0
	fi	


	if [ "$SERVICE" == "modules" ]
	then
		# modules
		iregister service
		iset need = initial
		iset use = modules/depmod
		iexec start = modules_start
		idone
		
		exit 0
	fi
	
	# modules/* - Name is in $SERVICE and known to iregister
	iregister service
	iset need = initial
	# Initng needs to load modules to mountroot, and depmod needs mountroot ... iset use = modules/depmod
	iset stdall = /dev/null
	iexec start = mod_load
	iexec stop = mod_unload
	idone
	exit 0
}

depmod_start()
{
		# Should not fail if kernel do not have module
		# support compiled in ...
		[ -f /proc/modules ] || exit 0

		# Here we should fail, as a modular kernel do need
		# depmod command ...
		if [ ! -e /lib/modules/`/bin/uname -r`/modules.dep ]
		then
			if [ ! -x /sbin/depmod ]
			then
				echo "ERROR:  system is missing /sbin/depmod !"
				exit 1
			fi
			/sbin/depmod
			exit 0
		else
			echo "Found modules.dep, skipping depmod ..."
		fi


		# if /etc/modules.d is newer then /etc/modules.conf

		if [ /etc/modules.d -nt /etc/modules.conf ]
		then
			echo "Calculating module dependencies ..."
			if [ ! -x /sbin/depmod ]
			then
				echo "ERROR:  system is missing /sbin/depmod !"
				exit 1
			fi
			/sbin/depmod
			exit 0
		else
			echo "Module dependencies up to date ..."
		fi

		wait
		if [ -x /sbin/lrm-manager ]
		then
			/sbin/lrm-manager --quick
		fi
		wait
		exit 0
}



mod_load()
{
	/sbin/modprobe ${NAME} || true
}

mod_unload()
{
	/sbin/modprobe -r ${NAME} || true
}

modules_start()
{
		load_modules() {
			[ -r "${1}" ] || return 1
			/bin/grep -v "^#" "${1}" | /bin/grep -v "^$" | while read MODULE MODARGS
			do
				echo "Loading module \"${MODULE}\" ..."
				/sbin/modprobe -q ${MODULE} ${MODARGS}
			done
		}
		# GENTOO: Don't probe kernel version, initng, requires 2.6 anyway
		load_modules /etc/modules.autoload.d/kernel-2.6
		load_modules /etc/modules
		if [ -n "`/sbin/modprobe -l -t boot \*`" ]
		then	
			echo "Loading of modules in /lib/modules/boot is broken!"
			# Don't add -l here - it suppresses the error message,
			# but it also prevents the modules from being loaded
			/sbin/modprobe -a -t boot \*
		fi
		exit 0  # Bad things happen if we fail
}
