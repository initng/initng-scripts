# NAME: MPD
# DESCRIPTION: Music Player Daemon
# WWW: http://www.musicpd.org

setup()
{
	ireg daemon daemon/mpd
	iset need = service/alsasound system/bootmisc
	iset stdall = /dev/null
	iset pid_file = "/var/run/mpd/mpd.pid"
	iset respawn
	iset exec daemon = "@/usr/bin/mpd@ --no-daemon --no-create-db /etc/mpd.conf"
	iset exec kill = "@/usr/bin/mpd@ --kill"
	idone
}
