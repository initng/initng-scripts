# SERVICE: service/alsasound/ioctl32
# NAME: ALSA
# DESCRIPTION: The Advanced Linux Sound Architecture
# WWW: http://www.alsa-project.org/

asoundcfg="/etc/asound.state"
alsascrdir="/etc/alsa.d"

setup()
{
	iregister task
		iset need = system/bootmisc
		iset use = system/coldplug system/modules/depmod \
		           system/modules
		iset once
		iexec task
	idone
}

task()
{
	# We want to ensure snd-ioctl32 is loaded as it is needed for 32bit
	# compatibility
	for mod in `@/sbin/modprobe@ -l | @sed@ -ne '{ s|.*/\([^/]*\)\.ko$|\1|; /^snd[_-]ioctl32/p}'`; do
		@/sbin/modprobe@ ${mod} &
	done
	wait
}
