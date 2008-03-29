# SERVICE: system/agetty/*
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
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
		iset exec daemon = "@/sbin/agetty@ 38400 ${NAME} ${TT}"
	idone
}
