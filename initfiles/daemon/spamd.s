# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset stdall = /dev/null

	iset exec daemon = "@/usr/bin/spamd@ -c"

	idone
}

