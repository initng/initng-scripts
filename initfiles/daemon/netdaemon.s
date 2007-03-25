# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset use = "system/coldplug system/modules"
	iset pid_of = netdaemon

	iexec daemon = "@/usr/sbin/netdaemon@"

	idone
}

