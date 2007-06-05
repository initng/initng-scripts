# SERVICE: service/alsasound/cards
# NAME: ALSA
# DESCRIPTION: The Advanced Linux Sound Architecture
# WWW: http://www.alsa-project.org/

asoundcfg="/etc/asound.state"
alsascrdir="/etc/alsa.d"

setup()
{
	iregister service
		iset need = system/bootmisc
		iset use = system/coldplug system/modules/depmod \
		           system/modules
		iexec start
	idone
}

start()
{
	# List of drivers for each card.
	for mod in `@/sbin/modprobe@ -c | @awk@ '$1 == "alias" && $2 ~ /^snd-card-[[:digit:]]$/ { print $2 } {}'`; do
		@/sbin/modprobe@ ${mod} &
	done
	wait

	# Fall back on the automated aliases,
	# if we do not have ALSA configured properly...
	[ -d /proc/asound ] &&
		@grep@ -q ' no soundcards ' /proc/asound/cards || exit 0

	echo "Could not detect custom ALSA settings.  Loading all detected alsa drivers."
	for mod in `@/sbin/modprobe@ -c | @awk@ '$2~ /^pci:/ && $3~ /^snd.*/ { print $3 }' | sort -u`; do
		@/sbin/modprobe@ ${mod} &
	done
	wait
}
