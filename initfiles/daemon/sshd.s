# NAME: OpenSSH
# DESCRIPTION: The standard Linux SSH server
# WWW: http://www.openssh.com/

KEYGEN="/usr/bin/ssh-keygen"
RSA1_KEY="/etc/ssh/ssh_host_key"
RSA_KEY="/etc/ssh/ssh_host_rsa_key"
DSA_KEY="/etc/ssh/ssh_host_dsa_key"

setup()
{
	ireg service daemon/sshd/generate_keys
	iexec start = generate_keys
	idone

	ireg daemon daemon/sshd
	iset need = system/bootmisc virtual/net
	iset conflict = daemon/dropbear
	iset use = daemon/sshd/generate_keys
	iset pid_file = "/var/run/sshd.pid"
	iset forks
	iset daemon_stops_badly
	iexec daemon = "@/usr/sbin/sshd@"
	idone
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
