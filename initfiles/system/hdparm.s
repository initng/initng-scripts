# NAME:
# DESCRIPTION:
# WWW:

#ifd gentoo
CONFFILE=/etc/conf.d/hdparm
#elsed debian
CONFFILE=/etc/default/hdparm
#endd

setup()
{
	ireg service system/hdparm && {
		iset need = system/initial
		iexec start
	}
}

start()
{
	[ -f "${CONFFILE}" ] || exit 0
	. "${CONFFILE}"
	for device in /dev/hd?
	do
		# check that the block device really exists
		# by opening it for reading
		if [ -b ${device} ] && @true@ <${device} 2>/dev/null
		then
			eval args=\${${device##*/}_args}
			if [ -n "${args:=${all_args}}" ]
			then
				orgdevice=`readlink -f ${device}`
				if [ -b "${orgdevice}" ]
				then
					@hdparm@ ${args} ${device} >/dev/null ||
					echo "Failed to run hdparm on ${device}." &
				fi
			fi
		fi
	done
	wait
	exit 0
}
