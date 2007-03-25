# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister -s "system/getty/1" daemon
	iregister -s "system/getty/*" daemon
	iregister -s "system/getty" virtual

	iset -s "system/getty/1" need = "system/bootmisc system/mountfs/home"
	iset -s "system/getty/1" provide = "virtual/getty/1"
	iset -s "system/getty/1" term_timeout = 3
	iset -s "system/getty/1" respawn
	iset -s "system/getty/1" last
	iset -s "system/getty/*" need = "system/bootmisc system/mountfs/home"
	iset -s "system/getty/*" provide = "virtual/getty/${NAME}"
	iset -s "system/getty/*" term_timeout = 3
	iset -s "system/getty/*" respawn
	iset -s "system/getty" need = "system/getty/2 system/getty/3 system/getty/4 system/getty/5 system/getty/6"
	iset -s "system/getty" use = "system/mountfs/essential service/issue"

	iexec -s "system/getty/1" daemon = "@/sbin/getty@ 38400 tty1"
	iexec -s "system/getty/*" daemon = "@/sbin/getty@ 38400 tty${NAME}"

	idone -s "system/getty/1"
	idone -s "system/getty/*"
	idone -s "system/getty"
}

