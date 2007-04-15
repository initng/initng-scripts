# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg virtual system/qingy && {
		iset need = system/qingy/{2,3,4,5,6}
		iset use = system/mountfs/essential service/issue
		return 0
	}

	#system/qingy/*
	ireg daemon && {
		iset need = system/bootmisc system/mountfs/home
		iset provide = "virtual/getty/${NAME}"
		iset respawn
		[ "${NAME}" = 1 ] && iset last
		iset exec daemon = "@/sbin/qingy@ tty${NAME}"
	}
}
