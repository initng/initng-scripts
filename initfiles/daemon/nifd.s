# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset pid_file = "/var/run/nifd.pid"
	iset forks

	iexec daemon = "@/usr/bin/nifd@ -n"

	idone
}

