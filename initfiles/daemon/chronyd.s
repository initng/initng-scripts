# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset pid_file = "/var/run/chronyd.pid"
	iset forks

	iexec daemon = "/usr/sbin/chronyd -f /etc/chrony/chrony.conf"

	idone
}
