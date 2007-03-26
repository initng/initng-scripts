# NAME: ALSA
# DESCRIPTION: The Advanced Linux Sound Architecture
# WWW: http://www.alsa-project.org/

asoundcfg="/etc/asound.state"
alsascrdir="/etc/alsa.d"

setup()
{
	iregister -s "service/alsasound/cards" service
	iregister -s "service/alsasound/oss" service
	iregister -s "service/alsasound/seq" service
	iregister -s "service/alsasound/ioctl32" service
	iregister -s "service/alsasound/mixerstate" service
	iregister -s "service/alsasound" service

	iset -s "service/alsasound/cards" need = "system/bootmisc"
	iset -s "service/alsasound/cards" use = "system/coldplug system/modules/depmod system/modules"
	iset -s "service/alsasound/oss" need = "system/bootmisc"
	iset -s "service/alsasound/oss" use = "system/coldplug system/modules/depmod system/modules"
	iset -s "service/alsasound/seq" need = "system/bootmisc"
	iset -s "service/alsasound/seq" use = "system/coldplug system/modules/depmod system/modules"
	iset -s "service/alsasound/ioctl32" need = "system/bootmisc"
	iset -s "service/alsasound/ioctl32" use = "system/coldplug system/modules/depmod system/modules"
	iset -s "service/alsasound/mixerstate" need = "system/bootmisc service/alsasound"
	iset -s "service/alsasound/mixerstate" exec stop = "@alsactl@ -f ${asoundcfg} store"
	iset -s "service/alsasound" need = "system/bootmisc"
	iset -s "service/alsasound" use = "system/coldplug service/alsasound/cards service/alsasound/ioctl32 service/alsasound/seq service/alsasound/oss system/modules/depmod system/modules"
	iset -s "service/alsasound" also_stop = "service/alsasound/cards service/alsasound/ioctl32 service/alsasound/seq service/alsasound/oss"

	iexec -s "service/alsasound/cards" start = cards_start
	iexec -s "service/alsasound/oss" start = oss_start
	iexec -s "service/alsasound/seq" start = seq_start
	iexec -s "service/alsasound/ioctl32" start = ioctl32_start
	iexec -s "service/alsasound/mixerstate" start = mixerstate_start
	iexec -s "service/alsasound" start = alsasound_start

	idone -s "service/alsasound/cards"
	idone -s "service/alsasound/oss"
	idone -s "service/alsasound/seq"
	idone -s "service/alsasound/ioctl32"
	idone -s "service/alsasound/mixerstate"
	idone -s "service/alsasound"
}

cards_start()
{
		# List of drivers for each card.
		for mod in `@/sbin/modprobe@ -c | @awk@ '$1 == "alias" && $2 ~ /^snd-card-[[:digit:]]$/ { print $2 } {}'`
		do
			@/sbin/modprobe@ ${mod} &
		done
		wait

		# Fall back on the automated aliases,
		# if we do not have ALSA configured properly...
		[ -d /proc/asound ] && @grep@ -q ' no soundcards ' /proc/asound/cards || exit 0

		echo "Could not detect custom ALSA settings.  Loading all detected alsa drivers."
		for mod in `@/sbin/modprobe@ -c | @awk@ '$2~ /^pci:/ && $3~ /^snd.*/ { print $3 }' | sort -u`
		do
			@/sbin/modprobe@ ${mod} &
		done
		wait
}

oss_start()
{
		for mod in `@/sbin/modprobe@ -l | @grep@ "snd.*oss" | @sed@ -e "s:\/.*\/::" -e "s:\..*::"`
		do
			@/sbin/modprobe@ ${mod} &
		done
		wait
}

seq_start()
{
		# We want to ensure snd-seq is loaded as it is needed for things like
		# timidity even if we do not use a real sequencer.
		for mod in `@/sbin/modprobe@ -l | @sed@ -ne '{ s|.*/\([^/]*\)\.ko$|\1|; /^snd[_-]seq/ { /oss/ !p } }'`
		do
			@/sbin/modprobe@ ${mod} &
		done
		for mod in `@awk@ -F, '$2~ /^empty$/ { print $1 }' /proc/asound/seq/drivers`
		do
			@/sbin/modprobe@ ${mod} &
		done
		wait
}

ioctl32_start()
{
		# We want to ensure snd-ioctl32 is loaded as it is needed for 32bit
		# compatibility
		for mod in `@/sbin/modprobe@ -l | @sed@ -ne '{ s|.*/\([^/]*\)\.ko$|\1|; /^snd[_-]ioctl32/ p}'`
		do
			@/sbin/modprobe@ ${mod} &
		done
		wait
}

mixerstate_start()
{
		if [ ! -r "${asoundcfg}" ]
		then
			echo "No mixer config in ${asoundcfg}, you have to unmute your card!"
			# this is not fatal!
		elif [ -x @/usr/sbin/alsactl@ ]
		then
			for CARDNUM in `@awk@ '/: / { print $1 }' /proc/asound/cards`
			do
				@/usr/sbin/alsactl@ -f ${asoundcfg} restore ${CARDNUM} &
			done
			wait
		else
			echo "ERROR: Cannot find alsactl, did you forget to install media-sound/alsa-utils?"
			exit 1
		fi
		exit 0
}

alsasound_start()
{
		for DRIVER in `@/sbin/lsmod@ | @awk@ '$1~/^snd.*/{print $1}'`
		do
			TMP=${DRIVER##snd-}
			TMP=${TMP##snd_}
			if [ -x "${alsascrdir}/${TMP}" ]
			then
				echo "  Running: ${alsascrdir}/${TMP} ..."
				${alsascrdir}/${TMP}
			fi
		done
}
