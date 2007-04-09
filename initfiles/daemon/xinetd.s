# NAME: xinetd
# DESCRIPTION: inetd replacement
# WWW: http://www.xinetd.org

#ifd gentoo
. /etc/conf.d/xinetd
#endd

setup()
{
	ireg daemon daemon/xinetd
	iset need = system/bootmisc virtual/net
	iexec daemon
	idone
}

daemon()
{
	exec @/usr/sbin/xinetd@ -dontfork ${XINETD_OPTS}
}
