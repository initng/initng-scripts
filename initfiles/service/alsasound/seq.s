# SERVICE: service/alsasound/seq
# NAME: ALSA
# DESCRIPTION: The Advanced Linux Sound Architecture
# WWW: http://www.alsa-project.org/

asoundcfg="/etc/asound.state"
alsascrdir="/etc/alsa.d"

setup() {
	iregister service
		iset need = system/bootmisc
		iset use = system/coldplug system/modules/depmod \
		           system/modules
		iexec start
	idone
}

start() {
	# We want to ensure snd-seq is loaded as it is needed for things like
	# timidity even if we do not use a real sequencer.
	for mod in `@/sbin/modprobe@ -l | @sed@ -ne '{ s|.*/\([^/]*\)\.ko$|\1|; /^snd[_-]seq/ { /oss/ !p } }'`; do
		@/sbin/modprobe@ ${mod} &
	done
	for mod in `@awk@ -F, '$2~ /^empty$/ { print $1 }' /proc/asound/seq/drivers`; do
		@/sbin/modprobe@ ${mod} &
	done
	wait
}
