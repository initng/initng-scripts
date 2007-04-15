# NAME:
# DESCRIPTION:
# WWW:

setup()
{
#ifd debian linspire pingwinek ubuntu
	ireg service net/all && {
		iset stdall = "/dev/null"
		iset need = system/bootmisc
		iset use = system/modules system/coldplug
#ifd linspire
		iset need = system/los-networking
#elsed ubuntu
		iset use = system/ifupdown-debian daemon/cardmgr
#elsed debian linspire
		iset need = system/ifupdown-debian
		iset use = daemon/cardmgr
#endd
		iset provide = virtual/net
		iexec start = all_start
		iexec stop = all_stop
		return 0
	}
#endd

	ireg service net/lo && {
		iset need = system/bootmisc
		iset provide = virtual/net/lo
		iset use = system/modules system/coldplug
#ifd ubuntu
		iset use = system/ifupdown-debian
#elsed debian linspire
		iset need = system/ifupdown-debian
#endd
#ifd gentoo
		iset exec start = "${INITNG_PLUGIN_DIR}/scripts/net/interface ${NAME} start"
		iset exec stop = "${INITNG_PLUGIN_DIR}/scripts/net/interface ${NAME} stop"
#elsed arch
		iset exec start = "@/sbin/ifconfig@ lo up"
		iset exec stop = "@/sbin/ifconfig@ lo down"
#elsed enlisy
		iset exec start = "/sbin/enlisy-net lo start"
		iset exec stop = "/sbin/enlisy-net lo stop"
#elsed
		iset exec start = "@/sbin/ifup@ lo"
		iset exec stop = "@/sbin/ifdown@ lo"
#endd
		return 0
	}

	ireg service && {
		iset stdall = "/dev/null"
		iset need = system/bootmisc
#ifd ubuntu
		iset use = system/ifupdown-debian
#elsed debian linspire
		iset need = system/ifupdown-debian
#endd
		iset use = system/modules system/coldplug daemon/cardmgr
		iset provide = virtual/net virtual/net/${NAME}
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
		iexec start = net_any_start
		iexec stop = net_any_stop
#endd
	}
}

#ifd debian linspire ubuntu
all_start()
{
	mkdir -p /var/run/network
	for i in $(@awk@ '$0~/^auto / { for (i=2; i<=NF; i++) print $i }' /etc/network/interfaces)
	do
		ngc -u net/${i} &
	done
	wait
}

all_stop()
{
	for i in $(@awk@ '$0~/^auto / { for (i=2; i<=NF; i++) print $i }' /etc/network/interfaces)
	do
		ngc -d net/${i} &
	done
	wait
}
#elsed pingwinek

all_start()
{
	/etc/net/scripts/initconf write
	/etc/net/scripts/network.init start
}

all_stop()
{
	/etc/net/scripts/network.init stop
}
#endd

#ifd gentoo arch enlisy
#elsed
net_any_start()
{
	# Put up the interface
	@/sbin/ifup@ ${NAME}
	# Check so its up
	@ifconfig@ ${NAME} | @grep@ -qF "UP" || exit 1
	exit 0
}

net_any_stop()
{
	set -e
	# Shut down.
	@/sbin/ifdown@ ${NAME}
	# Check so its down.
	# @ifconfig@ ${NAME} | @grep@ -qF "UP" && exit 1
	exit 0
}
#endd
