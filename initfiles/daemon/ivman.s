# NAME: ivman
# DESCRIPTION: Automounter
# WWW: http://ivman.sf.net

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/dbus daemon/hald"
	iset pid_file = "/var/run/ivman.pid"
	iset forks

	iexec daemon = "@/usr/bin/ivman@"

	idone
}

