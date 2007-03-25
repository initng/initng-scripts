# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister -s "system/mingetty/1" daemon
	iregister -s "system/mingetty/*" daemon
	iregister -s "system/mingetty" virtual

	iset -s "system/mingetty/1" need = "system/bootmisc system/mountfs/home"
	iset -s "system/mingetty/1" provide = "virtual/getty/1"
	iset -s "system/mingetty/1" term_timeout = 3
	iset -s "system/mingetty/1" respawn
	iset -s "system/mingetty/1" last
	iset -s "system/mingetty/*" need = "system/bootmisc system/mountfs/home"
	iset -s "system/mingetty/*" provide = "virtual/getty/${NAME}"
	iset -s "system/mingetty/*" term_timeout = 3
	iset -s "system/mingetty/*" respawn
	iset -s "system/mingetty" need = "system/mingetty/2 system/mingetty/3 system/mingetty/4 system/mingetty/5 system/mingetty/6"
	iset -s "system/mingetty" use = "system/mountfs/essential service/issue"

	iexec -s "system/mingetty/1" daemon = "@/sbin/mingetty@ tty1"
	iexec -s "system/mingetty/*" daemon = "@/sbin/mingetty@ tty${NAME}"

	idone -s "system/mingetty/1"
	idone -s "system/mingetty/*"
	idone -s "system/mingetty"
}

