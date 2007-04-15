# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/mDNSResponder && {
		iset need = system/bootmisc virtual/net
		iset pid_file = "/var/run/mDNSResponder.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/mDNSResponder:/usr/bin/mDNSResponder@"
	}
}
