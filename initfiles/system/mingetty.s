# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	if ireg virtual system/mingetty; then
		iset need = system/mingetty/{2,3,4,5,6}
		iset use = system/mountfs/essential service/issue
		return 0
	fi

	ireg daemon #system/mingetty/*
	iset need = system/bootmisc system/mountfs/home
	iset provide = "virtual/getty/${NAME}"
	iset term_timeout = 3
	iset respawn
	[ "${NAME}" = 1 ] && iset last
	iset exec daemon = "@/sbin/mingetty@ tty${NAME}"
}
