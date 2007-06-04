# SERVICE: service/alsasound/oss
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
	for mod in `@/sbin/modprobe@ -l | @grep@ "snd.*oss" | @sed@ -e "s:\/.*\/::" -e "s:\..*::"`; do
		@/sbin/modprobe@ ${mod} &
	done
	wait
}
