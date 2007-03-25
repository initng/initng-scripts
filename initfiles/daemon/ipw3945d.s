# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon

	iset need = "system/bootmisc system/mountfs/essential system/modules/ipw3945"

	iexec daemon = "@/sbin/ipw3945d@ --foreground --timeout"

	idone
}

