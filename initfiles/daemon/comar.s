# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc"

	iexec daemon = "@/usr/bin/comar@"

	idone
}

