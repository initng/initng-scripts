# NAME: Dropbear
# DESCRIPTION: SSH client with small memory footprint
# WWW: http://matt.ucc.asn.au/dropbear/dropbear.html

KEYGEN="/usr/bin/ssh-keygen"
RSA1_KEY="/etc/dropbear/ssh_host_key"
RSA_KEY="/etc/dropbear/dropbear_rsa_host_key"
DSA_KEY="/etc/ssh/dropbear_dsa_host_key"
DROPBEAR_PORT="22"
DROPBEAR_EXTRA_ARGS=""
NO_START="0"
source /etc/default/dropbear

setup()
{
	iregister -s "daemon/dropbear/generate_keys" service
	iregister -s "daemon/dropbear" daemon

	iset -s "daemon/dropbear" need = "system/bootmisc virtual/net"
	iset -s "daemon/dropbear" conflict = "daemon/sshd"
	iset -s "daemon/dropbear" use = "daemon/dropbear/generate_keys"
	iset -s "daemon/dropbear" pid_file = "/var/run/dropbear.pid"
	iset -s "daemon/dropbear" forks
	iset -s "daemon/dropbear" daemon_stops_badly

	iexec -s "daemon/dropbear/generate_keys" daemon = generate_keys_daemon
	iexec -s "daemon/dropbear" daemon = dropbear_daemon

	idone -s "daemon/dropbear/generate_keys"
	idone -s "daemon/dropbear"
}

generate_keys_daemon()
{
		[ ! -s ${RSA1_KEY} ] && \
			${KEYGEN} -q -t rsa1 -f ${RSA1_KEY} -C '' -N '' 2>&1 >/dev/null
		if [ ! -s ${RSA_KEY} ]
		then
			${KEYGEN} -q -t rsa -f ${RSA_KEY} -C '' -N '' 2>&1 >/dev/null
			chmod 600 ${RSA_KEY}
			chmod 644 ${RSA_KEY}.pub
		fi
		if [ ! -s ${DSA_KEY} ]
		then
			${KEYGEN} -q -t dsa -f ${DSA_KEY} -C '' -N '' 2>&1 >/dev/null
			chmod 600 ${DSA_KEY}
			chmod 644 ${DSA_KEY}.pub
		fi
	}
}


dropbear_daemon()
{
		test -z "$DROPBEAR_BANNER" || \
		  DROPBEAR_EXTRA_ARGS="$DROPBEAR_EXTRA_ARGS -b $DROPBEAR_BANNER"
		test -n "$DROPBEAR_RSAKEY" || \
		  DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
		test -n "$DROPBEAR_DSSKEY" || \
		  DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
	        test "$NO_START" = "0" || echo 'NO_START is not set to zero.' && exit 1
	       	exec @/usr/sbin/dropbear@ -F -d "$DROPBEAR_DSSKEY" -r "$DROPBEAR_RSAKEY" \
		    -p "$DROPBEAR_PORT" $DROPBEAR_EXTRA_ARGS
        }

}
