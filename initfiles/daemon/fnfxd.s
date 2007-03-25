# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset use = "daemon/acpid"
	iset pid_file = "/var/run/fnfxd.pid"
	iset forks

	iexec daemon = "@fnfxd@"

	idone
}

