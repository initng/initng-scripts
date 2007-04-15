# NAME: ivman
# DESCRIPTION: Automounter
# WWW: http://ivman.sf.net

setup()
{
	ireg daemon daemon/ivman && {
		iset need = system/bootmisc daemon/dbus daemon/hald
		iset pid_file = "/var/run/ivman.pid"
		iset forks
		iset exec daemon = "@/usr/bin/ivman@"
	}
}
