# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister -s "system/fgetty/1" daemon
	iregister -s "system/fgetty/*" daemon
	iregister -s "system/fgetty" virtual

	iset -s "system/fgetty/1" need = "system/bootmisc system/mountfs/home"
	iset -s "system/fgetty/1" provide = "virtual/getty/1"
	iset -s "system/fgetty/1" term_timeout = 3
	iset -s "system/fgetty/1" respawn
	iset -s "system/fgetty/1" last
	iset -s "system/fgetty/*" need = "system/bootmisc system/mountfs/home"
	iset -s "system/fgetty/*" provide = "virtual/getty/${NAME}"
	iset -s "system/fgetty/*" term_timeout = 3
	iset -s "system/fgetty/*" respawn
	iset -s "system/fgetty" need = "system/fgetty/2 system/fgetty/3 system/fgetty/4 system/fgetty/5 system/fgetty/6"
	iset -s "system/fgetty" use = "system/mountfs/essential service/issue"

	iexec -s "system/fgetty/1" daemon = "@/sbin/fgetty@ tty1"
	iexec -s "system/fgetty/*" daemon = "@/sbin/fgetty@ tty${NAME}"

	idone -s "system/fgetty/1"
	idone -s "system/fgetty/*"
	idone -s "system/fgetty"
}

