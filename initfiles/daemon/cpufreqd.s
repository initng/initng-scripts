# SERVICE: daemon/cpufreqd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset exec daemon = "@/usr/sbin/cpufreqd@ --no-daemon"
	idone
}
