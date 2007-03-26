# NAME: 
# DESCRIPTION: 
# WWW: 

#ifd gentoo
source /etc/conf.d/rsyncd
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"

#ifd gentoo
	iset exec daemon = "@/usr/bin/rsync@ ${RSYNC_OPTS} --daemon --no-detach"
#elsed
	iset exec daemon = "@/usr/bin/rsync@ --daemon --no-detach"
#endd

	idone
}

