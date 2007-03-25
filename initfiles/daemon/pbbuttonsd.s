# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon

	iset need = "service/alsasound virtual/net/lo"

	iexec daemon = "/usr/bin/pbbuttonsd"

	idone
}

