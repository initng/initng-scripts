# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset pid_file = "/var/run/fakeidentd.pid"
	iset forks

	iexec daemon = "@/usr/sbin/fakeidentd@ mafteah"

	idone
}

