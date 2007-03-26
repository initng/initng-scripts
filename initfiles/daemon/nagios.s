# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset pid_file = "/var/run/nagios.pid"
	iset forks

	iset exec daemon = "/usr/bin/nagios -d /etc/nagios/nagios.cfg"

	idone
}

