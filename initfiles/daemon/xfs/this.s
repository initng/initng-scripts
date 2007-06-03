# SERVICE: daemon/xfs
# NAME: xfs
# DESCRIPTION: The X font server
# WWW: http://xorg.freedesktop.org

#ifd gentoo
XFS_PORT="-1"
. /etc/conf.d/xfs
#endd

setup()
{
	iregister daemon
		iset need = system/bootmisc
#ifd gentoo
#elsed
		iset need = daemon/xfs/chkfontpath
#endd
#ifd debian
		iset exec daemon = "@/usr/X11R6/bin/xfs@ -droppriv -nodaemon"
#elsed gentoo
		iset exec daemon = "@/usr/bin/xfs@ -nodaemon -config /etc/X11/fs/config -droppriv -user xfs -port ${XFS_PORT}"
#elsed
		iset exec daemon = "@/usr/bin/xfs@ -droppriv -nodaemon"
#endd
	idone
}
