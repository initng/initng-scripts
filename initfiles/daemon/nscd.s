# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/nscd
	iset need = system/bootmisc
	iset pid_file = "/var/run/nscd/nscd.pid"
	iset forks
	iset exec daemon = "@/usr/sbin/nscd@"
	idone
}
