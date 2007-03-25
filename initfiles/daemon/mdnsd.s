# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset pid_file = "/var/run/mdnsd.pid"
	iset forks

	iexec daemon = "@/usr/sbin/mdnsd@"

	idone
}

