# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg virtual system/getty && {
		iset need = system/getty/{2,3,4,5,6}
		iset use = system/mountfs/essential service/issue
		return 0
	}

	ireg daemon && {
		iset need = system/bootmisc system/mountfs/home
		iset provide = "virtual/getty/$NAME"
		iset term_timeout = 3
		iset respawn
		[ "${NAME}" = 1 ] && iset last
		iset exec daemon = "@/sbin/getty@ 38400 tty$NAME"
	}
}
