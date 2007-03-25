# NAME: MPD
# DESCRIPTION: Music Player Daemon
# WWW: http://www.musicpd.org

setup()
{
	iregister daemon

	iset need = "service/alsasound system/bootmisc"
	iset stdall = /dev/null
	iset pid_file = "/var/run/mpd/mpd.pid"
	iset respawn

	iexec daemon = "@/usr/bin/mpd@ --no-daemon --no-create-db /etc/mpd.conf"
	iexec kill = "@/usr/bin/mpd@ --kill"

	idone
}

