# SERVICE: daemon/postfix/newaliases
# NAME: Postfix
# DESCRIPTION: sendmail-compatible mail transport agent
# WWW: http://www.postfix.org/

setup() {
	iregister service
		iset need = system/bootmisc
		iset exec start = "@newaliases@"
	idone
}
