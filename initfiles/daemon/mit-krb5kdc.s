# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"

	iexec daemon = "/usr/sbin/krb5kdc -n"

	idone
}

