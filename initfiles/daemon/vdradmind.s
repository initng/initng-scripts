# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/vdradmind && {
		iset need = system/bootmisc
		iset use = daemon/vdr daemon/svdrpd
		iset pid_file = "/var/run/vdradmind.pid"
		iset stdout = /dev/null
		iset forks
		iset exec daemon = "@vdradmind.pl@"
		iset exec kill = "@vdradmind.pl@ --kill"
	}
}
