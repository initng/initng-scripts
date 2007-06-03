# SERVICE: daemon/bluetooth/sdpd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc daemon/bluetooth/hcid
		iset pid_of = sdpd
		iset forks
		iset respawn
		iset exec daemon = "@/usr/sbin/sdpd@"
	idone
}
