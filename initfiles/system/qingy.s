# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	if is_service system/qingy
	then
		ireg virtual
		iset need = system/qingy/2 system/qingy/3 system/qingy/4 system/qingy/5 system/qingy/6
		iset use = system/mountfs/essential service/issue
		idone
		exit 0
	fi

	ireg daemon #system/qingy/*
	iset need = system/bootmisc system/mountfs/home
	iset provide = "virtual/getty/${NAME}"
	iset respawn
	[ "${NAME}" = 1 ] && iset last
	iset exec daemon = "@/sbin/qingy@ tty${NAME}"
	idone
}
