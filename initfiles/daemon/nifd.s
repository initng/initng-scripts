# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/nifd
	iset need = system/bootmisc
	iset pid_file = "/var/run/nifd.pid"
	iset forks
	iset exec daemon = "@/usr/bin/nifd@ -n"
	idone
}
