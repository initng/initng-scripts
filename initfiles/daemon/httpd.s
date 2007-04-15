# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/httpd && {
		iset need = system/bootmisc virtual/net
		iset use = daemon/sshd daemon/mysql daemon/postgres system/mountfs
		iset respawn
		iset pid_file = "/var/run/httpd.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/httpd@"
	}
}
