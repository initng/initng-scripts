# SERVICE: daemon/entranced
# NAME: Entrance
# DESCRIPTION: Graphical login/display manager
# WWW: http://xcomputerman.com/pages/entrance.html

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset provide = virtual/dm
		iset conflict = daemon/xdm daemon/kdm daemon/gdm daemon/wdm \
		                daemon/slim
		iset pid_file = "/var/run/entranced.pid"
		iset respawn
		iset forks
		iset exec daemon = "@/usr/sbin/entranced@"
	idone
}
