# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/bluetooth/hcid"
	iset pid_of = sdpd
	iset forks
	iset respawn

	iexec daemon = "@/usr/sbin/sdpd@"

	idone
}

