# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/fnfxd && {
		iset need = system/bootmisc
		iset use = daemon/acpid
		iset pid_file = "/var/run/fnfxd.pid"
		iset forks
		iset exec daemon = "@fnfxd@"
	}
}
