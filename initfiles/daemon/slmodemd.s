# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc service/alsasound"

	iexec daemon = "@/usr/sbin/slmodemd@ --country"

	idone
}

