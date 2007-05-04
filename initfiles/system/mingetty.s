# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg virtual system/mingetty && {
		iset need = system/mingetty/2 system/mingetty/3 \
			    system/mingetty/4 system/mingetty/5 \
			    system/mingetty/6
		iset use = system/mountfs/essential service/issue
		return 0
	}

	# system/mingetty/*
	ireg daemon && {
		iset need = system/bootmisc system/mountfs/home
		iset provide = "virtual/getty/${NAME}"
		iset term_timeout = 3
		iset respawn
		[ "${NAME}" = 1 ] && iset last
		iset exec daemon = "@/sbin/mingetty@ tty${NAME}"
	}
}
