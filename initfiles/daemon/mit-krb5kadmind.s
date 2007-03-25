# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/mit-krb5kdc"

	iexec daemon = "@kadmind@ -nofork"

	idone
}

