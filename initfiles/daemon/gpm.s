# NAME: GPM
# DESCRIPTION: Console mouse driver
# WWW: http://linux.schottelius.org/gpm/

#ifd debian
device="/dev/input/mice"
type="imps2"
append=""
source /etc/gpm.conf
#elsed
MOUSE="imps2"
MOUSEDEV="/dev/input/mice"
APPEND=""
source /etc/conf.d/gpm
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
#ifd debian
#elsed
	iset pid_file = "/var/run/gpm.pid"
	iset forks
#endd

#ifd debian
	iexec daemon = gpm_daemon
#elsed
	iexec daemon = "@/usr/sbin/gpm@ -m ${MOUSEDEV} -t ${MOUSE} ${APPEND}"
#endd

	idone
}

#ifd debian
gpm_daemon()
{
		[ -n "${responsiveness}" ] && responsiveness="-r ${responsiveness}"
		[ -n "${sample_rate}" ] && sample_rate="-s ${sample_rate}"
		# Yes, this /IS/ correct! There is no space after -R!!!!!!
		# I reserve the right to throw manpages at anyone who disagrees.
		[ -n "${repeat_type}" -a "${repeat_type}" != "none" ] && append="-R${repeat_type} ${append}"
		# If both the second device and type are specified, use it.
		[ -n "${device2}" -a -n "${type2}" ] && append="-M -m ${device2} -t ${type2} ${append}"
		exec @/usr/sbin/gpm@ -m "${device}" -t "${type}" ${append} -D
}
#endd