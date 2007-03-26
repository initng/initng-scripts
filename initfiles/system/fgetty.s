# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	if [ "${NAME}" = fgetty ]
	then
		iregister virtual
		iset need = "system/fgetty/2 system/fgetty/3 system/fgetty/4 system/fgetty/5 system/fgetty/6"
		iset use = "system/mountfs/essential service/issue"
		idone
		exit 0
	fi

	iregister daemon
	iset need = "system/bootmisc system/mountfs/home"
	iset provide = "virtual/getty/${NAME}"
	iset term_timeout = 3
	iset respawn
	[ "${NAME}" = 1 ] && iset last
	iset exec daemon = "@/sbin/fgetty@ tty${NAME}"
	idone
}
