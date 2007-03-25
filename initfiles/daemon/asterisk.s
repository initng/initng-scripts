# NAME: Asterisk
# DESCRIPTION: Highly configurable modular software PABX (phone system)
# WWW: http://www.asterisk.org

ASTERISK_USER =" asterisk:asterisk"
#ifd debian
source /etc/default/asterisk
#elsed
source /etc/conf.d/asterisk
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset use = "daemon/postgres daemon/mysql"
	iset suid = ${ASTERISK_USER}

	iexec daemon = "@/usr/sbin/asterisk@ ${ASTERISK_OPTS}"

	idone
}

