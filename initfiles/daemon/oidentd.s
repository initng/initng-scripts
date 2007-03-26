# NAME: 
# DESCRIPTION: 
# WWW: 

OIDENT_OPTIONS=""
OIDENT_USER="nobody"
OIDENT_GROUP="nogroup"
#ifd debian
source /etc/default/oidentd
#endd

setup()
{
	iregister daemon

	iset need = "system/initial system/mountroot virtual/net"

	iset exec daemon = oidentd_daemon

	idone
}

oidentd_daemon()
{
		if [ "${OIDENT_BEHIND_PROXY}" = "yes" ]
		then
			# If we have a default router, then allow it to proxy auth requests to us
			GATEWAY=`netstat -nr | @awk@ '/^0.0.0.0/{print $2}'`
			[ -n "${GATEWAY}" ] && OIDENT_OPTIONS="${OIDENT_OPTIONS} -P ${GATEWAY}"
		fi
		exec @/usr/sbin/oidentd@ -i ${OIDENT_OPTIONS} -u ${OIDENT_USER} -g ${OIDENT_GROUP}
}
