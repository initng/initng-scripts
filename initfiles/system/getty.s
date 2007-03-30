# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	# SERVICE: system/getty
	if [ "${NAME}" = getty ]
	then
		iregister virtual
		iset need = "system/getty/2 system/getty/3 system/getty/4 system/getty/5 system/getty/6"
		iset use = "system/mountfs/essential service/issue"
		idone
		exit 0
	fi

	# SERVICE: system/getty/*
	iregister daemon
	iset need = "system/bootmisc system/mountfs/home"
	iset provide = "virtual/getty/${NAME}"
	iset term_timeout = 3
	iset respawn
	[ "${NAME}" = 1 ] && iset last
	iset exec daemon = "@/sbin/getty@ 38400 tty${NAME}"
	idone
}
