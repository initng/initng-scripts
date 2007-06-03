# SERVICE: daemon/nut/upsmon
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon 
		iset need = system/bootmisc daemon/nut/upsd daemon/nut/upsdrv
		iset forks
		iset respawn
		iset pid_file = "/var/run/upsmon.pid"
		iset exec daemon = "@/usr/sbin/upsmon@"
		iset exec kill = "@/usr/sbin/upsmon@ -c stop"
	idone
}
