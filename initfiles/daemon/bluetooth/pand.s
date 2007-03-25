# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/bluetooth/hcid"

	iexec daemon = "@/usr/bin/pand@ --nodetach --listen --role NAP"

	idone
}

