# NAME:
# DESCRIPTION:
# WWW:

MINI_HTTPD_DOCROOT=/
source /etc/conf.d/mini_httpd

setup()
{
	export SERVICE="daemon/mini_httpd"
	iregister daemon
	iset need = "system/bootmisc virtual/net"
	iexec daemon
	idone
}

daemon()
{
	cd "${MINI_HTTPD_DOCROOT}"
	exec @/usr/sbin/mini_httpd@ -D -i /var/run/mini_httpd.pid ${MINI_HTTPD_OPTS}
}
