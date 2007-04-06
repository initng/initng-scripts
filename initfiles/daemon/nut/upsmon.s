# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/nut/upsmon
	iset need = system/bootmisc daemon/nut/upsd daemon/nut/upsdrv
	iset forks
	iset respawn
	iset pid_file = "/var/run/upsmon.pid"
	iset exec daemon = "@/usr/sbin/upsmon@"
	iset exec kill = "@/usr/sbin/upsmon@ -c stop"
	idone
}
