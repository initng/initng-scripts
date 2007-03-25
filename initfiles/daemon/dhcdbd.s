# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/dbus"
	iset pid_file = "/var/run/dhcdbd.pid"
	iset forks

	iexec daemon = "@/sbin/dhcdbd@ --system"

	idone
}

