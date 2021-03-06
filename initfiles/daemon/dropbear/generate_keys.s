# SERVICE: daemon/dropbear/generate_keys
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
	iregister service
		iset need = system/bootmisc
		iexec start
	idone
}

start() {
	[ ! -s ${RSA1_KEY} ] &&
		${KEYGEN} -q -t rsa1 -f ${RSA1_KEY} -C '' -N '' 2>&1 >/dev/null

	if [ ! -s ${RSA_KEY} ]; then
		${KEYGEN} -q -t rsa -f ${RSA_KEY} -C '' -N '' 2>&1 >/dev/null
		chmod 600 ${RSA_KEY}
		chmod 644 ${RSA_KEY}.pub
	fi

	if [ ! -s ${DSA_KEY} ]; then
		${KEYGEN} -q -t dsa -f ${DSA_KEY} -C '' -N '' 2>&1 >/dev/null
		chmod 600 ${DSA_KEY}
		chmod 644 ${DSA_KEY}.pub
	fi
}
