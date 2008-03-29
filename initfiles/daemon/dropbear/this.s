# SERVICE: daemon/dropbear
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

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset conflict = daemon/sshd
		iset use = daemon/dropbear/generate_keys
		iset pid_file = "/var/run/dropbear.pid"
		iset forks
		iset daemon_stops_badly
		iexec daemon
	idone
}

daemon() {
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

       	exec @/usr/sbin/dropbear@ -F -d "$DROPBEAR_DSSKEY" \
		-r "$DROPBEAR_RSAKEY" -p "$DROPBEAR_PORT" \
		"$DROPBEAR_EXTRA_ARGS"
}
