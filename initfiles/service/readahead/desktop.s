# SERVICE: service/readahead/desktop
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/mountfs/essential
		iexec start
	idone
}

start() {
	[ -e /etc/readahead/desktop -a -x @/sbin/readahead-watch@ ] &&
		exec @/sbin/readahead-watch@ -o /etc/readahead/desktop
	exit 0
}
