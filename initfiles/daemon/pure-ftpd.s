# NAME: Pure-FTPd
# DESCRIPTION: Secure, production-quality and standard-conformant FTP server.
# WWW: http://www.pureftpd.org/project/pure-ftpd

#ifd gentoo
source /etc/conf.d/pure-ftpd
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset use = "daemon/mysql"
	iset pid_file = "/var/run/pure-ftpd.pid"
	iset forks

#ifd gentoo
	iexec daemon = "@/usr/sbin/pure-ftpd@ $SERVER $MAX_CONN $MAX_CONN_IP $DISK_FULL $USE_NAT $AUTH $LOG $TIMEOUT $MISC_OTHER"
#elsed enlisy
	iexec daemon = "@/usr/sbin/pure-config.py@ /etc/pure-ftpd.conf"
#elsed
	iexec daemon = "@/usr/sbin/pure-config.pl@ /etc/pure-ftpd/pure-ftpd.conf"
#endd

	idone
}

