# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/cpufreqd
	iset need = system/bootmisc
	iset exec daemon = "@/usr/sbin/cpufreqd@ --no-daemon"
	idone
}
