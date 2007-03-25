# NAME:
# DESCRIPTION:
# WWW:

#ifd gentoo
source /etc/conf.d/hdparm
#elsed debian
source /etc/default/hdparm
#endd

setup()
{
	iregister service

	iset need = "system/initial"

	iexec start = hdparm_start

	idone
}

hdparm_start()
{
		do_hdparm() {
			if [ -n "${args:=${all_args}}" ]
			then
				orgdevice=`readlink -f ${device}`
				if [ -b "${orgdevice}" ]
				then
					@hdparm@ ${args} ${device} >/dev/null || echo "Failed to run hdparm on ${device}." &
				fi
			fi
		}

		if [ -d /dev/ide ]
		then
			# devfs compatible systems
			for device in `@find@ /dev/ide -name disc`
			do
				args=''
				for alias in /dev/hd?
				do
					if [ "${alias}" -ef "${device}" ]
					then
						device=${alias}
						eval args=\${${alias##*/}_args}
						break
					fi
				done

				[ -z "${args}" ] && for alias in /dev/discs/*
				do
					if [ "${alias}/disc" -ef "${device}" ]
					then
						device=${alias}/disc
						eval args=\${${alias##*/}_args}
						break
					fi
				done
				do_hdparm
			done

			for device in `@find@ /dev/ide -name cd`
			do
				args=''
				for alias in /dev/hd?
				do
					if [ "${alias}" -ef "${device}" ]
					then
						device=${alias}
						eval args=\${${alias##*/}_args}
						break
					fi
				done

				[ -z "${args}" ] && for alias in /dev/cdroms/*
				do
					if [ "${alias}" -ef "${device}" ]
					then
						device=${alias}
						eval args=\${${alias##*/}_args}
						break
					fi
				done
				do_hdparm
			done

			let count=0
			# of course, the sort approach would fail here if any of the
			# host/bus/target/lun numbers reached 2 digits..
			for device in `@find@ /dev/ide -name generic | sort`
			do
				eval args=\${generic${count}_args}
				do_hdparm
				let count=count+1
			done

		else

			# non-devfs compatible system
			for device in /dev/hd?
			do
				# check that the block device really exists
				# by opening it for reading
				if [ -b ${device} ] && @true@ <${device} 2>/dev/null
				then
					eval args=\${${device##*/}_args}
					do_hdparm
				fi
			done
		fi
		exit 0
}
