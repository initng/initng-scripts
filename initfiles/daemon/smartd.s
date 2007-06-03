# SERVICE: daemon/smartd
# NAME: smartmontools
# DESCRIPTION: Monitoring daemon for S.M.A.R.T. hard drive diagnostics
# WWW: http://smartmontools.sourceforge.net

#ifd fedora mandriva
. /etc/sysconfig/smartmontools
#elsed debian
. /etc/default/smartmontools
#elsed
[ -f /etc/conf.d/smartd ] && . /etc/conf.d/smartd
#endd

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset forks
		iset pid_of = smartd
#ifd fedora
#elsed
		iset pid_file = "/var/run/smartd.pid"
#endd
		iexec daemon
	idone
}

daemon()
{
#ifd fedora mandriva
	[ -f /etc/smartd.conf ] || smartd-conf.py > /etc/smartd.conf
#endd
#ifd debian fedora mandriva
	exec @/usr/sbin/smartd@ -p /var/run/smartd.pid ${smartd_opts}
#elsed
	exec @/usr/sbin/smartd@ -p /var/run/smartd.pid ${SMARTD_OPTS}
#endd
}
