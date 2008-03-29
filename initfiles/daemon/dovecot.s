# SERVICE: daemon/dovecot
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset exec daemon = "@/usr/sbin/dovecot@ -F"
	idone
}
