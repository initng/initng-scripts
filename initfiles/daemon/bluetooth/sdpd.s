# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/bluetooth/sdpd && {
		iset need = system/bootmisc daemon/bluetooth/hcid
		iset pid_of = sdpd
		iset forks
		iset respawn
		iset exec daemon = "@/usr/sbin/sdpd@"
	}
}
