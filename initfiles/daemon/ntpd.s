# NAME:
# DESCRIPTION:
# WWW:

#ifd gentoo
. /etc/conf.d/ntpd
#endd

setup()
{
	ireg daemon daemon/ntpd
	iset need = system/bootmisc virtual/net
	iset use = service/ntpdate
	iset pid_file = "/var/run/ntpd.pid"
	iset forks
	iset exec daemon = "@/usr/sbin/ntpd@ -p /var/run/ntpd.pid ${NTPD_OPTS}"
	idone
}
