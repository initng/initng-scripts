# SERVICE: daemon/rsyncd
# NAME:
# DESCRIPTION:
# WWW:

#ifd gentoo
[ -f /etc/conf.d/rsyncd ] && . /etc/conf.d/rsyncd
#endd

setup()
{
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset exec daemon = "@/usr/bin/rsync@ ${RSYNC_OPTS} --daemon --no-detach"
	idone
}
