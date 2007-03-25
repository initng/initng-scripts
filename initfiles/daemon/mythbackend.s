# NAME: MythTV
# DESCRIPTION: Backend server for the mythtv PVR
# WWW: http://www.mythtv.org

HOME =" /etc/mythtv"

setup()
{
	iregister daemon

	iset need = "virtual/net/lo system/bootmisc"
	iset use = "daemon/mysql"
	iset suid = mythtv
	iset sgid = mythtv
	iset pid_of = mythbackend
	iset forks
	iset respawn

	iexec daemon = "@/usr/bin/mythbackend@"
#ifd gentoo
	iexec daemon = "--logfile /var/log/mythtv/mythbackend.log"
#endd

	idone
}

