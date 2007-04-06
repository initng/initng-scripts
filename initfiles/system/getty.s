# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	if is_service system/getty
	then
		ireg virtual
		iset need = system/getty/{2,3,4,5,6}
		iset use = system/mountfs/essential service/issue
		idone
		exit 0
	fi

	ireg daemon #system/getty/*
	iset need = system/bootmisc system/mountfs/home
	iset provide = "virtual/getty/${NAME}"
	iset term_timeout = 3
	iset respawn
	[ "${NAME}" = 1 ] && iset last
	iset exec daemon = "@/sbin/getty@ 38400 tty${NAME}"
	idone
}
