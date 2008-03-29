# SERVICE: daemon/vixie-cron
# NAME: vixie-cron
# DESCRIPTION: A fully featured crond implementation
# WWW: ftp://ftp.isc.org/isc/cron

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset provide = virtual/cron
		iset exec daemon = "@/usr/sbin/cron@ -f"
	idone
}
