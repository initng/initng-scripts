# NAME: Asterisk
# DESCRIPTION: Highly configurable modular software PABX (phone system)
# WWW: http://www.asterisk.org

ASTERISK_USER="asterisk"
#ifd debian
	source /etc/default/asterisk
#elsed
	source /etc/conf.d/asterisk
#endd

setup()
{
	ireg daemon daemon/asterisk
	iset need = system/bootmisc virtual/net
	iset use = daemon/postgres daemon/mysql
	iset suid = "${ASTERISK_USER}"
	iexec daemon
	idone
}

daemon()
{
	exec @/usr/sbin/asterisk@ ${ASTERISK_OPTS}
}
