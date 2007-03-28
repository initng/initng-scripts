# NAME: HPLIP
# DESCRIPTION: Hewlett-Packard Linux Imaging and Printing - Imaging Daemon
# WWW: http://hplip.sf.net

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net/lo"
#ifd debian
	iset pid_file = "/var/run/hplip/hpiod.pid"
#elsed
	iset pid_file = "/var/run/hpiod.pid"
#endd
	iset forks

	iset exec daemon = "@/usr/sbin/hpiod@"

	idone
}
