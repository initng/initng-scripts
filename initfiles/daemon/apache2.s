# NAME: Apache2
# DESCRIPTION: The Apache web server, version 2
# WWW: http://httpd.apache.org

#ifd debian
	. /etc/default/apache2
#elsed
	[ -f /etc/conf.d/apache2 ] && . /etc/conf.d/apache2
#endd

setup()
{
	ireg daemon daemon/apache2
	iset need = system/bootmisc virtual/net
	iset use = daemon/sshd daemon/mysql daemon/postgres system/mountfs
	iset respawn
	iset pid_file = "/var/run/apache2.pid"
	iset forks
	iexec daemon
	iset exec kill = "@/usr/sbin/apache2@ -k stop"
	idone
}

daemon()
{
	 exec @/usr/sbin/apache2@ ${APACHE2_OPTS} -k start
}
