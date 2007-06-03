# SERVICE: daemon/dhcdbd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc daemon/dbus
		iset pid_file = "/var/run/dhcdbd.pid"
		iset forks
		iset exec daemon = "@/sbin/dhcdbd@ --system"
	idone
}
