# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset pid_file = "/var/run/nscd/nscd.pid"
	iset forks

	iexec daemon = "@/usr/sbin/nscd@"

	idone
}

