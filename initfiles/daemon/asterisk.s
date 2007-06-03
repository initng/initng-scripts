# SERVICE: daemon/asterisk
# NAME: Asterisk
# DESCRIPTION: Highly configurable modular software PABX (phone system)
# WWW: http://www.asterisk.org

ASTERISK_USER="asterisk"
#ifd debian
[ -f /etc/default/asterisk ] && . /etc/default/asterisk
#elsed
[ -f /etc/conf.d/asterisk ] && . /etc/conf.d/asterisk
#endd

setup()
{
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset use = daemon/postgres daemon/mysql
		iset suid = "${ASTERISK_USER}"
		iset exec daemon = "@/usr/sbin/asterisk@ ${ASTERISK_OPTS}"
	idone
}
