# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/mit-krb5kdc"

	iset exec daemon = "@kadmind@ -nofork"

	idone
}

