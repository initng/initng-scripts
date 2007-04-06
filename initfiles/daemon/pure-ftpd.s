# NAME: Pure-FTPd
# DESCRIPTION: Secure, production-quality and standard-conformant FTP server.
# WWW: http://www.pureftpd.org/project/pure-ftpd

#ifd gentoo
source /etc/conf.d/pure-ftpd
#endd

setup()
{
	ireg daemon daemon/pure-ftpd
	iset need = system/bootmisc
	iset use = daemon/mysql
	iset pid_file = "/var/run/pure-ftpd.pid"
	iset forks
#ifd gentoo
	iset exec daemon = "@/usr/sbin/pure-ftpd@ ${SERVER} ${MAX_CONN} ${MAX_CONN_IP} ${DISK_FULL} ${USE_NAT} ${AUTH} ${LOG} ${TIMEOUT} ${MISC_OTHER}"
#elsed enlisy
	iset exec daemon = "@/usr/sbin/pure-config.py@ /etc/pure-ftpd.conf"
#elsed
	iset exec daemon = "@/usr/sbin/pure-config.pl@ /etc/pure-ftpd/pure-ftpd.conf"
#endd
	idone
}
