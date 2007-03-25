# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset use = "daemon/vdr daemon/svdrpd"
	iset pid_file = "/var/run/vdradmind.pid"
	iset stdout = /dev/null
	iset forks

	iexec daemon = "@vdradmind.pl@"
	iexec kill = "@vdradmind.pl@ --kill"

	idone
}

