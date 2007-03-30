# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="daemon/dcron"
	iregister daemon
	iset need = "system/bootmisc"
	iset provide = "virtual/cron"
	iset exec daemon = "@/usr/sbin/crond@ -n"
	idone
}
