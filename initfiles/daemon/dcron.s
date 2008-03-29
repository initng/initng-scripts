# SERVICE: daemon/dcron
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset provide = virtual/cron
		iset exec daemon = "@/usr/sbin/crond:/usr/sbin/cron@ -n"
	idone
}
