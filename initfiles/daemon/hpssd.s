# NAME: HPLIP
# DESCRIPTION: Hewlett-Packard Linux Imaging and Printing - Settings and Status Daemon
# WWW: http://hplip.sourceforge.net

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/hpiod"
#ifd debian
	iset pid_file = "/var/run/hplip/hpssd.pid"
#elsed
	iset pid_file = "/var/run/hpssd.pid"
#endd
	iset forks

#ifd debian
	iset exec daemon = "@/usr/sbin/hpssd@"
#elsed
	iset exec daemon = "@/usr/share/hplip/hpssd.py@"
#endd

	idone
}

