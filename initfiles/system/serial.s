# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/initial system/mountroot system/modules/serial"

	iexec start = serial_start

	idone
}

serial_start()
{
		if [ -e /etc/serial.conf ]
		then
			@grep@ -v "^#\|^ \|^$" /etc/serial.conf | while read device args
			do
				@/bin/setserial@ -b ${device} ${args} 1>&2
			done
		fi
}
