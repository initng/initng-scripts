# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/dhcdbd
	iset need = system/bootmisc daemon/dbus
	iset pid_file = "/var/run/dhcdbd.pid"
	iset forks
	iset exec daemon = "@/sbin/dhcdbd@ --system"
	idone
}
