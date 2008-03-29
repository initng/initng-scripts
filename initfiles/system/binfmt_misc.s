# SERVICE: system/binfmt_misc
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/bootmisc
		iset exec stop = "@sysctl@ -n -w fs.binfmt_misc.status"
		iexec start
	idone
}

start() {
	@grep@ '^\s*#' /etc/binfmt | @grep@ '^\s*$' | while read line; do
		@sysctl@ -n -w fs.binfmt_misc.register="${line}"
	done
}
