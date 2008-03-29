# SERVICE; net/ip/*
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/bootmisc
		iset use = "net/bridge/${NAME}" "net/iwconfig/${NAME}"
		iset provide = virtual/net "virtual/net/${NAME}"
		iexec start
		iexec stop
	idone
}

start() {
	eval @ip@ addr add \${config_$NAME} ${NAME}
	@ip@ link set ${NAME} up
}

stop() {
	@ip@ link set ${NAME} down
	eval @ip@ addr del \${config_$NAME} ${NAME}
}
