# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	if is_service system/fgetty
	then
		ireg virtual
		iset need = system/fgetty/{2,3,4,5,6}
		iset use = system/mountfs/essential service/issue
		idone
		exit 0
	fi

	ireg daemon #system/fgetty/*
	iset need = system/bootmisc system/mountfs/home
	iset provide = "virtual/getty/${NAME}"
	iset term_timeout = 3
	iset respawn
	[ "${NAME}" = 1 ] && iset last
	iset exec daemon = "@/sbin/fgetty@ tty${NAME}"
	idone
}
