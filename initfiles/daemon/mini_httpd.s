# NAME: 
# DESCRIPTION: 
# WWW: 

source /etc/conf.d/mini_httpd

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset chdir = ${MINI_HTTPD_DOCROOT}

	iset exec daemon = "/usr/sbin/mini_httpd -D -i /var/run/mini_httpd.pid ${MINI_HTTPD_OPTS}"

	idone
}

