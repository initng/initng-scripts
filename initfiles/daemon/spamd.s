# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset stdall = /dev/null

	iexec daemon = "@/usr/bin/spamd@ -c"

	idone
}

