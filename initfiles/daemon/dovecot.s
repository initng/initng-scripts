# SERVICE: daemon/dovecot
# NAME: Dovecot
# DESCRIPTION: IMAP and POP3 server, written with security primarily in mind.
# WWW: http://www.dovecot.org/

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset exec daemon = "@/usr/sbin/dovecot@ -F"
	idone
}
