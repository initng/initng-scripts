# SERVICE: daemon/sendmail
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset use = daemon/sendmail/prepare
		iset provide = virtual/mta
		iset exec daemon = "@/usr/sbin/sendmail@ -q1h -bD"
	idone
}
