# SERVICE: system/getty/*
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc system/mountfs/home
		iset provide = "virtual/getty/$NAME"
		iset term_timeout = 3
		iset respawn
		[ "${NAME}" = 1 ] && iset last
		iset exec daemon = "@/sbin/getty@ 38400 tty$NAME"
	idone
}
