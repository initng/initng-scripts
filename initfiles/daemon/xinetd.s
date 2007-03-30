# NAME: xinetd
# DESCRIPTION: inetd replacement
# WWW: http://www.xinetd.org

#ifd gentoo
source /etc/conf.d/xinetd
#elsed
XINETD_OPTS=
#endd

setup()
{
	export SERVICE="daemon/xinetd"
	iregister daemon
	iset need = "system/bootmisc virtual/net"
	iexec daemon
	idone
}

daemon()
{
	exec @/usr/sbin/xinetd@ -dontfork ${XINETD_OPTS}
}
