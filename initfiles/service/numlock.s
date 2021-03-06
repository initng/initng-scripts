# SERVICE: service/numlock
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial system/mountfs/essential
		iexec start
		iexec stop
	idone
}

start() {
	for tty in 1 2 3 4 5 6 7 8 9 10 11 12; do
		@setleds@ -D +num < /dev/tty${tty} >/dev/null 2>&1
	done
}

stop() {
	for tty in 1 2 3 4 5 6 7 8 9 10 11 12; do
		@setleds@ -D -num < /dev/tty${tty} >/dev/null 2>&1
	done
}
