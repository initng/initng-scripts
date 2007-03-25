# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/nut/upsd daemon/nut/upsdrv"
	iset forks
	iset respawn
	iset pid_file = "/var/run/upsmon.pid"

	iexec daemon = "@/usr/sbin/upsmon@"
	iexec kill = "@/usr/sbin/upsmon@ -c stop"

	idone
}

