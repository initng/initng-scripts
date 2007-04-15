# NAME: vixie-cron
# DESCRIPTION: A fully featured crond implementation
# WWW: ftp://ftp.isc.org/isc/cron

setup()
{
	ireg daemon daemon/vixie-cron && {
		iset need = system/bootmisc
		iset provide = virtual/cron
#ifd gentoo
		iset pid_file = "/var/run/cron.pid"
#elsed
		iset pid_file = "/var/run/crond.pid"
#endd
		iset forks
		iset exec daemon = "@/usr/sbin/cron@"
	}
}
