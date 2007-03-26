# NAME: xinetd
# DESCRIPTION: inetd replacement
# WWW: http://www.xinetd.org

#ifd gentoo
source /etc/conf.d/xinetd
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"

	iset exec daemon = "@/usr/sbin/xinetd@ -dontfork ${XINETD_OPTS}"

	idone
}

