# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset pid_file = "/var/run/mDNSResponder.pid"
	iset forks

	iexec daemon = "@/usr/sbin/mDNSResponder:/usr/bin/mDNSResponder@"

	idone
}

