# SERVICE: daemon/sshd
# NAME: OpenSSH
# DESCRIPTION: The standard Linux SSH server
# WWW: http://www.openssh.com/

setup()
{

	iregister daemon
		iset need = system/bootmisc virtual/net
		iset conflict = daemon/dropbear
		iset use = daemon/sshd/generate_keys
		iset pid_file = "/var/run/sshd.pid"
		iset forks
		iset daemon_stops_badly
		iexec daemon = "@/usr/sbin/sshd@"
	idone
}
