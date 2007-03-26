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
	iexec start
	idone
}

start()
{
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
