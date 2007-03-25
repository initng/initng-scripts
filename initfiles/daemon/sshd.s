# NAME: OpenSSH
# DESCRIPTION: The standard Linux SSH server
# WWW: http://www.openssh.com/

KEYGEN="/usr/bin/ssh-keygen"
RSA1_KEY="/etc/ssh/ssh_host_key"
RSA_KEY="/etc/ssh/ssh_host_rsa_key"
DSA_KEY="/etc/ssh/ssh_host_dsa_key"

setup()
{
	iregister -s "daemon/sshd/generate_keys" service
	iregister -s "daemon/sshd" daemon

	iset -s "daemon/sshd" need = "system/bootmisc virtual/net"
	iset -s "daemon/sshd" conflict = "daemon/dropbear"
	iset -s "daemon/sshd" use = "daemon/sshd/generate_keys"
	iset -s "daemon/sshd" pid_file = "/var/run/sshd.pid"
	iset -s "daemon/sshd" forks
	iset -s "daemon/sshd" daemon_stops_badly

	iexec -s "daemon/sshd/generate_keys" start = generate_keys_start
	iexec -s "daemon/sshd" daemon = "@/usr/sbin/sshd@"

	idone -s "daemon/sshd/generate_keys"
	idone -s "daemon/sshd"
}

generate_keys_start()
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

