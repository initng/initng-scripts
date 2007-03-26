# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"

	iset exec daemon = "/usr/sbin/krb5kdc -n"

	idone
}

