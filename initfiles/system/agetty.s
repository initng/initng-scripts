# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister -s "system/agetty/1" daemon
	iregister -s "system/agetty/*" daemon
	iregister -s "system/agetty" virtual

	iset -s "system/agetty/1" need = "system/bootmisc system/mountfs/home"
	iset -s "system/agetty/1" provide = "virtual/getty/1"
	iset -s "system/agetty/1" term_timeout = 3
	iset -s "system/agetty/1" respawn
	iset -s "system/agetty/1" last
	iset -s "system/agetty/*" need = "system/bootmisc system/mountfs/home"
	iset -s "system/agetty/*" provide = "virtual/getty/${NAME}"
	iset -s "system/agetty/*" term_timeout = 3
	iset -s "system/agetty/*" respawn
	iset -s "system/agetty" need = "system/agetty/2 system/agetty/3 system/agetty/4 system/agetty/5 system/agetty/6"
	iset -s "system/agetty" use = "system/mountfs/essential service/issue"

	iexec -s "system/agetty/1" daemon = "@/sbin/agetty@ 38400 tty1"
	iexec -s "system/agetty/*" daemon = agetty_any_daemon

	idone -s "system/agetty/1"
	idone -s "system/agetty/*"
	idone -s "system/agetty"
}

agetty_any_daemon()
{
		case ${NAME} in
			S*)
				TERMTYPE=vt100
				;;
		esac
		exec @/sbin/agetty@ 38400 tty${NAME} ${TERMTYPE}
}
