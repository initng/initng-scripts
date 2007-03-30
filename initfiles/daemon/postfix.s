# NAME: Postfix
# DESCRIPTION: sendmail-compatible mail transport agent
# WWW: http://www.postfix.org/

setup()
{
	export SERVICE="daemon/postfix/pwcheck"
	iregister daemon
	iset need = "system/bootmisc"
	iset pid_file = "/var/run/pwcheck.pid"
	iset forks
	iset exec daemon = "@/usr/sbin/pwcheck@"
	idone

	export SERVICE="daemon/postfix/newaliases"
	iregister service
	iset need = "system/bootmisc"
	iset exec start = "@newaliases@"
	idone

	export SERVICE="daemon/postfix"
	iregister daemon
#ifd fedora mandriva
	iset need = "daemon/postfix/newaliases"
#endd
	iset need = "system/bootmisc"
	iset use = "daemon/postfix/pwcheck"
	iset provide = "virtual/mta"
	iset pid_file = "/var/spool/postfix/pid/master.pid"
	iset forks
	iset exec daemon = "@postfix@ start"
	iset exec kill = "@postfix@ stop"
	idone
}
