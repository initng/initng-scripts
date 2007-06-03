# SERVICE: daemon/nut/upsd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc daemon/nut/upsdrv virtual/net
		iset forks
		iset respawn
		iset pid_file = "/var/lib/nut/upsd.pid"
		iset exec daemon = "@/usr/sbin/upsd@"
	idone
}
