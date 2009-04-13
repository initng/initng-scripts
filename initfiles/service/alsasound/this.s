# SERVICE: service/alsasound
# NAME: ALSA
# DESCRIPTION: The Advanced Linux Sound Architecture
# WWW: http://www.alsa-project.org/

asoundcfg="/etc/asound.state"
alsascrdir="/etc/alsa.d"

setup() {
	iregister service
		iset need = system/bootmisc
		iset use = system/coldplug system/modules \
		           service/alsasound/cards service/alsasound/ioctl32 \
			   service/alsasound/seq service/alsasound/oss
		# Bring down these subservices if service/alsasound is stopped
		iset also_stop = service/alsasound/cards \
				 service/alsasound/ioctl32 \
				 service/alsasound/seq service/alsasound/oss
		iexec start
	idone
}

start() {
	[ -e /proc/modules ] || exit 0

	for DRIVER in `@/sbin/lsmod@ | @awk@ '$1~/^snd.*/{print $1}'`; do
		TMP=${DRIVER##snd-}
		TMP=${TMP##snd_}
		if [ -x "${alsascrdir}/${TMP}" ]; then
			echo "  Running: ${alsascrdir}/${TMP} ..."
			${alsascrdir}/${TMP}
		fi
	done
}
