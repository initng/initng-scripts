#!/sbin/runiscript

setup()
{
	# All nics
	if [ "$SERVICE" == "net/all" ]
	then
		iregister service
		iset need = bootmisc 
		iexec start = all_start
		iexec stop = all_stop
		idone
		exit 0
	fi

	# Ordinary nics
	iregister service
	iset need = bootmisc
	iset provide = virtual/net virtual/net/${NAME}
	iset use = modules coldplug
	iexec start
	iexec stop
#ifd debian linspire
	iset need = ifupdown-debian;
#endd
	idone
	exit 0
}

all_start()
{
		mkdir -p /var/run/network
		for i in $(@awk@ '$0~/^auto / { for (i=2; i<=NF; i++) print $i }' /etc/network/interfaces)
		do
			ngc -u net/${i}
		done
		wait
}

all_stop()
{
		for i in $(@awk@ '$0~/^auto / { for (i=2; i<=NF; i++) print $i }' /etc/network/interfaces)
		do
			ngc -d net/${i}
		done
		wait
}

start()
{
#ifd gentoo
	exec ${INITNG_PLUGIN_DIR}/scripts/net/interface ${NAME} start
#elsed arch
	exec /sbin/ifconfig ${NAME} up
#elsed
	# Put up the interface
	@/sbin/ifup@ ${NAME}
	# Check so its up
	@ifconfig@ ${NAME} | @grep@ -qe "inet addr" -e "inet6 addr" || exit 1
	exit 0
#endd
}

stop()
{
#ifd gentoo
	exec ${INITNG_PLUGIN_DIR}/scripts/net/interface ${NAME} stop
#elsed arch
	exec /sbin/ifconfig ${NAME} down;
#elsed
		set -e
		# Shut down.
		@/sbin/ifdown@ ${NAME}
		# Check so its down.
		# @ifconfig@ ${NAME} | @grep@ -qe "inet addr" -e "inet6 addr" && exit 1
		exit 0
#endd
}

