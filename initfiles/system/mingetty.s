# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	if [ "${NAME}" = mingetty ]
	then
		iregister virtual
		iset      need = "system/mingetty/2 system/mingetty/3 system/mingetty/4 system/mingetty/5 system/mingetty/6"
		iset      use = "system/mountfs/essential service/issue"
		idone
		exit 0
	fi

	iregister daemon
	iset      need = "system/bootmisc system/mountfs/home"
	iset      provide = "virtual/getty/${NAME}"
	iset      term_timeout = 3
	iset      respawn
	[ "${NAME}" = 1 ] && iset last
	iset      exec daemon = "@/sbin/mingetty@ tty${NAME}"
	idone
}
