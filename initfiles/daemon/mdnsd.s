# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/mdnsd && {
		iset pid_file = "/var/run/mdnsd.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/mdnsd@"
	}
}
