# SERVICE: system/qingy/*
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc system/mountfs/home
		iset provide = "virtual/getty/${NAME}"
		iset respawn
		[ "${NAME}" = 1 ] && iset last
		iset exec daemon = "@/sbin/qingy@ ${NAME}"
	idone
}
