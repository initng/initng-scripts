# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc"

	iexec daemon = "@/usr/sbin/dhcpd@ -f"

	idone
}

