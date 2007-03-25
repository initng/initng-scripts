# NAME: Postfix
# DESCRIPTION: sendmail-compatible mail transport agent
# WWW: http://www.postfix.org/

setup()
{
	iregister -s "daemon/postfix/pwcheck" daemon
	iregister -s "daemon/postfix/newaliases" service
	iregister -s "daemon/postfix" daemon

	iset -s "daemon/postfix/pwcheck" need = "system/bootmisc"
	iset -s "daemon/postfix/pwcheck" pid_file = "/var/run/pwcheck.pid"
	iset -s "daemon/postfix/pwcheck" forks
	iset -s "daemon/postfix/newaliases" need = "system/bootmisc"
#ifd fedora mandriva
	iset -s "daemon/postfix" need = "daemon/postfix/newaliases"
#endd
	iset -s "daemon/postfix" need = "system/bootmisc"
	iset -s "daemon/postfix" use = "daemon/postfix/pwcheck"
	iset -s "daemon/postfix" provide = "virtual/mta"
	iset -s "daemon/postfix" pid_file = "/var/spool/postfix/pid/master.pid"
	iset -s "daemon/postfix" forks

	iexec -s "daemon/postfix/pwcheck" daemon = "@/usr/sbin/pwcheck@"
	iexec -s "daemon/postfix/newaliases" start = "@newaliases@"
	iexec -s "daemon/postfix" daemon = "@postfix@ start"
	iexec -s "daemon/postfix" kill = "@postfix@ stop"

	idone -s "daemon/postfix/pwcheck"
	idone -s "daemon/postfix/newaliases"
	idone -s "daemon/postfix"
}

