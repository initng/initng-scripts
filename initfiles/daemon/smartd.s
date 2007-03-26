# NAME: smartmontools
# DESCRIPTION: Monitoring daemon for S.M.A.R.T. hard drive diagnostics
# WWW: http://smartmontools.sourceforge.net

#ifd fedora mandriva
source /etc/sysconfig/smartmontools
#elsed debian
source /etc/default/smartmontools
#elsed
source /etc/conf.d/smartd
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset forks
	iset pid_of = smartd
#ifd fedora
#elsed
	iset pid_file = "/var/run/smartd.pid"
#endd

#ifd fedora mandriva
	iset exec daemon = smartd_daemon
#elsed debian
	iset exec daemon = "/usr/sbin/smartd -p /var/run/smartd.pid ${smartd_opts}"
#elsed
	iset exec daemon = "/usr/sbin/smartd -p /var/run/smartd.pid ${SMARTD_OPTS}"
#endd

	idone
}

#ifd fedora mandriva
smartd_daemon()
{
		[ -f /etc/smartd.conf ] || smartd-conf.py > /etc/smartd.conf
		/usr/sbin/smartd -p /var/run/smartd.pid ${smartd_opts}
}
#endd
