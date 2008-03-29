# SERVICE: daemon/postfix
# NAME: Postfix
# DESCRIPTION: sendmail-compatible mail transport agent
# WWW: http://www.postfix.org/

setup() {
	iregister daemon
#ifd fedora mandriva
		iset need = daemon/postfix/newaliases
#endd
		iset need = system/bootmisc
		iset use = daemon/postfix/pwcheck
		iset provide = virtual/mta
		iset pid_file = "/var/spool/postfix/pid/master.pid"
		iset forks
		iset exec daemon = "@postfix@ start"
		iset exec kill = "@postfix@ stop"
	idone
}
