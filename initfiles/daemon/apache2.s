# SERVICE: daemon/apache2
# NAME: Apache2
# DESCRIPTION: The Apache web server, version 2
# WWW: http://httpd.apache.org

#ifd debian
	[ -f /etc/default/apache2 ] && . /etc/default/apache2
#elsed
	[ -f /etc/conf.d/apache2 ] && . /etc/conf.d/apache2
#endd

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset use = daemon/sshd daemon/mysql daemon/postgres system/mountfs
		iset respawn
		iset pid_file = "/var/run/apache2.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/apache2@ ${APACHE2_OPTS} -k start"
		iset exec kill = "@/usr/sbin/apache2@ -k stop"
	idone
}
