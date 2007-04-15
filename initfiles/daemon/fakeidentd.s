# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/fakeidentd && {
		iset need = system/bootmisc virtual/net
		iset pid_file = "/var/run/fakeidentd.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/fakeidentd@ mafteah"
	}
}
