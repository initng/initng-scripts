# SERVICE: system/modules/*
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial
		[ "${NAME}" = dm-mod ] || iset use = system/modules/depmod
		iset stdall = /dev/null
		iexec start
		iexec stop
	idone
}

start() {
	@/sbin/modprobe@ -q ${NAME}
	exit 0
}

stop() {
	@/sbin/modprobe@ -q -r ${NAME}
	exit 0
}
