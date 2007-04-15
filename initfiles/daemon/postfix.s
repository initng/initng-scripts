# NAME: Postfix
# DESCRIPTION: sendmail-compatible mail transport agent
# WWW: http://www.postfix.org/

setup()
{
	ireg daemon daemon/postfix/pwcheck && {
		iset need = system/bootmisc
		iset pid_file = "/var/run/pwcheck.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/pwcheck@"
		return 0
	}

	ireg service daemon/postfix/newaliases && {
		iset need = system/bootmisc
		iset exec start = "@newaliases@"
		return 0
	}

	ireg daemon daemon/postfix && {
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
	}
}
