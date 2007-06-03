# SERVICE: daemon/postfix/pwcheck
# NAME: Postfix
# DESCRIPTION: sendmail-compatible mail transport agent
# WWW: http://www.postfix.org/

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset pid_file = "/var/run/pwcheck.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/pwcheck@"
	idone
}
