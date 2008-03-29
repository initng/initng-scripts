# SERVICE: daemon/cherokee
# NAME: Cherokee
# DESCRIPTION: Very fast, flexible and easy to configure web server.
# WWW: http://www.cherokee-project.com/

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset use = daemon/sshd daemon/mysql daemon/postgres system/mountfs
		iset respawn
		iset pid_file = "/var/run/cherokee.pid"
		iset forks
		iset exec daemon = "@cherokee@"
	idone
}
