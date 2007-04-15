# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/chronyd && {
		iset need = system/bootmisc virtual/net
		iset pid_file = "/var/run/chronyd.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/chronyd@ -f /etc/chrony/chrony.conf"
	}
}
