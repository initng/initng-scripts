# NAME: rlocate
# DESCRIPTION: Replacement for slocate that ensures up to date data
# WWW: http://rlocate.sourceforge.net/

setup()
{
	iregister daemon

	iset need = "system/bootmisc system/modules/rlocate"
	iset pid_file = "/var/run/rlocated.pid"
	iset forks
	iset daemon_stops_badly

	iset exec daemon = "@/usr/sbin/rlocated@"

	idone
}

