# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	if [ "${NAME}" = agetty ]
	then
		iregister virtual
		iset need = "system/agetty/2 system/agetty/3 system/agetty/4 system/agetty/5 system/agetty/6"
		iset use = "system/mountfs/essential service/issue"
		idone
		exit 0
	fi

	iregister daemon
	iset need = "system/bootmisc system/mountfs/home"
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
