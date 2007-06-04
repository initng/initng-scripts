# SERVICE: service/alsasound/mixerstate
# NAME: ALSA
# DESCRIPTION: The Advanced Linux Sound Architecture
# WWW: http://www.alsa-project.org/

asoundcfg="/etc/asound.state"
alsascrdir="/etc/alsa.d"

setup()
{
	iregister service
		iset need = system/bootmisc service/alsasound
		iset exec stop = "@alsactl@ -f ${asoundcfg} store"
		iexec start
	idone
}

start()
{
	if [ ! -r "${asoundcfg}" ]; then
		echo "No mixer config in ${asoundcfg}, you have to unmute your card!"
		# this is not fatal!
	elif [ -x @/usr/sbin/alsactl@ ]; then
		for CARDNUM in `@awk@ '/: / { print $1 }' /proc/asound/cards`; do
			@/usr/sbin/alsactl@ -f ${asoundcfg} restore ${CARDNUM} &
		done
		wait
	else
		echo "ERROR: Cannot find alsactl, did you forget to install media-sound/alsa-utils?"
		exit 1
	fi
	exit 0
}
