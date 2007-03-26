# NAME: atd
# DESCRIPTION: Scheduler with functionality similar to cron
# WWW: ftp://jurix.jura.uni-sb.de/pub/jurix/source/chroot/appl/at/

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset pid_file = "/var/run/atd.pid"
	iset forks

	iset exec daemon = "@/usr/sbin/atd@"

	idone
}

