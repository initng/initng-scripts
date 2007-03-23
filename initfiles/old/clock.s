#!/sbin/runiscript


#ifd debian linspire
source /etc/default/rcS;
#elsed fedora
source /etc/sysconf/clock;
#elsed
source /etc/conf.d/clock;
#endd

setup()
{
	# register new service type, the will be "example" here.
    iregister service

    iset need = initial
	iset use = modules
	
	# Call functions in this script.
	iexec start
	iexec stop
		
	# Tell initng this service is done parsing.
    idone
}

start()
{
		setupopts() {
			if @grep@ -q ' cobd$' /proc/devices 
			then
				TBLURB="coLinux"
				return 0
#ifd debian linspire
			elif [ "${UTC}" = "yes" ]
			then
#elsed
			elif [ "${CLOCK}" = "UTC" -o "${UTC}" = "true" ]
			then
#endd
				myopts="--utc"
				TBLURB="UTC"
			else
				myopts="--localtime"
				TBLURB="Local Time"
			fi

			if [ "${readonly}" = "yes" ]
			then
				myadj="--noadjfile"
			else
				myadj="--adjust"
			fi

			if [ "${SRM}" = "yes" -o "${SRM}" = "true" ]
			then
				myopts="${myopts} --srm"
			fi
			if [ "${ARC}" = "arc" -o "${ARC}" = "true" ]
			then
				myopts="${myopts} --arc"
			fi
			myopts="${myopts} ${CLOCK_OPTS}"

		# Make sure user isn't using rc.conf anymore.
			if @grep@ -qs ^CLOCK= /etc/rc.conf
			then
				echo "CLOCK should not be set in /etc/rc.conf but in /etc/conf.d/clock"
			fi
		}

		myopts=""
		myadj=""
		TBLURB=""
		errstr=""
		readonly="no"
		ret=0

		if ! touch /etc/adjtime 2>/dev/null
		then
			readonly="yes"
		elif [ ! -s /etc/adjtime ]
		then
			echo "0.0 0 0.0" > /etc/adjtime
		fi

		setupopts

		if [ "${TBLURB}" = "UML" -o "${TBLURB}" = "coLinux" ]
		then
			true
		elif [ -x @/sbin/hwclock@ ]
		then
			# Since hwclock always exit's with a 0, need to check its output.
			@/sbin/hwclock@ ${myadj} ${myopts}
			@/sbin/hwclock@ --hctosys ${myopts}
		fi
}

stop()
{
		setupopts() {
			if @grep@ -q ' cobd$' /proc/devices
			then
				TBLURB="coLinux"
				return 0
#ifd debian linspire
			elif [ "${UTC}" = "yes" ]
			then
#elsed
			elif [ "${CLOCK}" = "UTC" -o "${UTC}" = "true" ]
			then
#endd
				myopts="--utc"
				TBLURB="UTC"
			else
				myopts="--localtime"
				TBLURB="Local Time"
			fi

			if [ "${readonly}" = "yes" ]
			then
				myadj="--noadjfile"
			else
				myadj="--adjust"
			fi

			if [ "${SRM}" = "yes" -o "$SRM" = "true" ]
			then
				myopts="${myopts} --srm"
			fi
			if [ "${ARC}" = "arc" -o "$ARC" = "true" ]
			then
				myopts="${myopts} --arc"
			fi
			myopts="${myopts} ${CLOCK_OPTS}"

			# Make sure user isn't using rc.conf anymore.
			if @grep@ -qs ^CLOCK= /etc/rc.conf
			then
				echo "CLOCK should not be set in /etc/rc.conf but in /etc/conf.d/clock"
			fi
		}
		# Don't tweak the hardware clock on LiveCD halt.
		#[ -n ${CDBOOT} ] && return 0

		#[ ${CLOCK_SYSTOHC} != "yes" ] && return 0

		ret=0

		setupopts

		echo "Syncing system clock to hardware clock [${TBLURB}] ..."
		if [ "${CLOCK}" = "UML" ]
		then
			true
		elif [ -x @/sbin/hwclock@ ]
		then
			@/sbin/hwclock@ --systohc ${myopts}

			if [ -n "${errstr}" ]
			then
				ret=1
			else
				ret=0
			fi
		fi
}
