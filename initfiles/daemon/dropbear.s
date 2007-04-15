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
[ -f /etc/default/dropbear ] && . /etc/default/dropbear

setup()
{
	ireg service daemon/dropbear/generate_keys && {
		iexec start = generate_keys
		return 0
	}

	ireg daemon daemon/dropbear && {
		iset need = system/bootmisc virtual/net
		iset conflict = daemon/sshd
		iset use = daemon/dropbear/generate_keys
		iset pid_file = "/var/run/dropbear.pid"
		iset forks
		iset daemon_stops_badly
		iexec daemon
	}
}

generate_keys()
{
	[ ! -s ${RSA1_KEY} ] &&
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

daemon()
{
	[ -z "$DROPBEAR_BANNER" ] ||
		DROPBEAR_EXTRA_ARGS="$DROPBEAR_EXTRA_ARGS -b $DROPBEAR_BANNER"
	[ -n "$DROPBEAR_RSAKEY" ] ||
		DROPBEAR_RSAKEY="/etc/dropbear/dropbear_rsa_host_key"
	[ -n "$DROPBEAR_DSSKEY" ] ||
		DROPBEAR_DSSKEY="/etc/dropbear/dropbear_dss_host_key"
        [ "$NO_START" = "0" ] || {
        	echo 'NO_START is not set to zero.'
        	exit 1
        }

       	exec @/usr/sbin/dropbear@ -F -d "$DROPBEAR_DSSKEY" -r "$DROPBEAR_RSAKEY" \
	                          -p "$DROPBEAR_PORT" "$DROPBEAR_EXTRA_ARGS"
}
