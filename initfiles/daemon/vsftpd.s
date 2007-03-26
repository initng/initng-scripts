# NAME: vsftpd
# DESCRIPTION: Very Secure FTP Daemon
# WWW: http://vsftpd.beasts.org

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net/lo"
	iset use = "virtual/net"
	iset pid_of = vsftpd
	iset forks

	iset exec daemon = "/usr/sbin/vsftpd"

	idone
}

