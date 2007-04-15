# NAME: xinetd
# DESCRIPTION: inetd replacement
# WWW: http://www.xinetd.org

#ifd gentoo
[ -f /etc/conf.d/xinetd ] && . /etc/conf.d/xinetd
#endd

setup()
{
	ireg daemon daemon/xinetd && {
		iset need = system/bootmisc virtual/net
		iset exec daemon = " @/usr/sbin/xinetd@ -dontfork ${XINETD_OPTS}"
	}
}
