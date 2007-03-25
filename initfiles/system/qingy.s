# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister -s "system/qingy/1" daemon
	iregister -s "system/qingy/*" daemon
	iregister -s "system/qingy" virtual

	iset -s "system/qingy/1" need = "system/bootmisc system/mountfs/home"
	iset -s "system/qingy/1" provide = "virtual/getty/1"
	iset -s "system/qingy/1" respawn
	iset -s "system/qingy/1" last
	iset -s "system/qingy/*" need = "system/bootmisc system/mountfs/home"
	iset -s "system/qingy/*" provide = "virtual/getty/${NAME}"
	iset -s "system/qingy/*" respawn
	iset -s "system/qingy" need = "system/qingy/2 system/qingy/3 system/qingy/4 system/qingy/5 system/qingy/6"
	iset -s "system/qingy" use = "system/mountfs/essential service/issue"

	iexec -s "system/qingy/1" daemon = "@/sbin/qingy@ tty1"
	iexec -s "system/qingy/*" daemon = "@/sbin/qingy@ tty${NAME}"

	idone -s "system/qingy/1"
	idone -s "system/qingy/*"
	idone -s "system/qingy"
}

