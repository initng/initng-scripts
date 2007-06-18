# SERVICE: net/*
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset stdall = "/dev/null"
		iset need = system/bootmisc
#ifd ubuntu
		iset use = system/ifupdown-debian
#elsed debian linspire
		iset need = system/ifupdown-debian
#endd
		iset use = system/modules system/coldplug daemon/cardmgr
		iset provide = "virtual/net/${NAME}"
		iset provide = virtual/net
#ifd gentoo
		iset exec start = "${INITNG_PLUGIN_DIR}/scripts/net/interface ${NAME} start"
		iset exec stop = "${INITNG_PLUGIN_DIR}/scripts/net/interface ${NAME} stop"
#elsed arch
		iset exec start = "/sbin/ifconfig ${NAME} up"
		iset exec stop = "/sbin/ifconfig ${NAME} down"
#elsed enlisy
		iset exec start = "/sbin/enlisy-net ${NAME} start"
		iset exec stop = "/sbin/enlisy-net ${NAME} stop"
#elsed
		iexec start
		iexec stop
#endd
	idone
}

#ifd gentoo arch enlisy
#elsed
start()
{
	# Put up the interface
	@/sbin/ifup@ ${NAME}
	# Check so its up
	@ifconfig@ ${NAME} | @grep@ -qF "UP"
}

stop()
{
	# Shut down.
	@/sbin/ifdown@ ${NAME}
	exit 0
}
#endd
