# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/fcron
	iset need = system/bootmisc virtual/net/lo
	iset pid_file = "/var/run/fcron.pid"
	iset respawn
	iset forks
	iset exec daemon = "@/usr/sbin/fcron@"
	idone
}
