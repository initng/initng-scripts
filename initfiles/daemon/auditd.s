# SERVICE: daemon/auditd
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial system/bootmisc
		iset exec start = "@/etc/init.d/auditd@ start"
		iset exec stop = "@/etc/init.d/auditd@ stop"
	idone
}
