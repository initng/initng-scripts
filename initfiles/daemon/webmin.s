# NAME: Webmin
# DESCRIPTION: Web-based system configuration interface
# WWW: http://www.webmin.com

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset use = "daemon/syslog-ng daemon/syslogd"
	iset pid_file = "/var/run/webmin.pid"
	iset forks

	iset exec daemon = "/usr/libexec/webmin/miniserv.pl /etc/webmin/miniserv.conf"

	idone
}

