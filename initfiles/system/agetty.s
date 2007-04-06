# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	if is_service daemon/agetty
	then
		ireg virtual
		iset need = system/agetty/{2,3,4,5,6}
		iset use = system/mountfs/essential service/issue
		idone
		exit 0
	fi

	ireg daemon #daemon/agetty/*
	iset need = system/bootmisc system/mountfs/home
	iset provide = "virtual/getty/${NAME}"
	iset term_timeout = 3
	iset respawn
	TT=
	case "${NAME}" in
		1)
			iset last
			;;
		S*)
			TT=vt100
			;;
	esac
	iset exec daemon = "@/sbin/agetty@ 38400 tty${NAME} ${TT}"
	idone
}
