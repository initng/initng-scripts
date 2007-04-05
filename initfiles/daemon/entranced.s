# NAME: Entrance
# DESCRIPTION: Graphical login/display manager
# WWW: http://xcomputerman.com/pages/entrance.html

setup()
{
	ireg daemon daemon/entranced
	iset need = system/bootmisc
	iset provide = virtual/dm
	iset pid_file = "/var/run/entranced.pid"
	iset respawn
	iset forks
	iset exec daemon = "@/usr/sbin/entranced@"
	idone
}
