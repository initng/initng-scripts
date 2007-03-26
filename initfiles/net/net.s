# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
#ifd debian linspire pingwinek ubuntu
	iregister -s "net/all" service
#endd
	iregister -s "net/lo" service
	iregister -s "net/*" service

#ifd debian linspire pingwinek ubuntu
	iset -s "net/all" stdall = "/dev/null"
	iset -s "net/all" need = "system/bootmisc"
	iset -s "net/all" use = "system/modules system/coldplug"
#ifd linspire
	iset -s "net/all" need = "system/los-networking"
#elsed ubuntu
	iset -s "net/all" use = "system/ifupdown-debian daemon/cardmgr"
#elsed debian linspire
	iset -s "net/all" need = "system/ifupdown-debian"
	iset -s "net/all" use = "daemon/cardmgr"
#endd
	iset -s "net/all" provide = "virtual/net"
#endd
	iset -s "net/lo" need = "system/bootmisc"
	iset -s "net/lo" provide = "virtual/net/lo"
	iset -s "net/lo" use = "system/modules system/coldplug"
#ifd ubuntu
	iset -s "net/lo" use = "system/ifupdown-debian"
#elsed debian linspire
	iset -s "net/lo" need = "system/ifupdown-debian"
#endd
#ifd gentoo
	iset -s "net/lo" exec start = "${INITNG_PLUGIN_DIR}/scripts/net/interface ${NAME} start"
	iset -s "net/lo" exec stop = "${INITNG_PLUGIN_DIR}/scripts/net/interface ${NAME} stop"
#elsed arch
	iset -s "net/lo" exec start = "@/sbin/ifconfig@ lo up"
	iset -s "net/lo" exec stop = "@/sbin/ifconfig@ lo down"
#elsed enlisy
	iset -s "net/lo" exec start = "/sbin/enlisy-net lo start"
	iset -s "net/lo" exec stop = "/sbin/enlisy-net lo stop"
#elsed
	iset -s "net/lo" exec start = "@/sbin/ifup@ lo"
	iset -s "net/lo" exec stop = "@/sbin/ifdown@ lo"
#endd
	iset -s "net/*" stdall = "/dev/null"
	iset -s "net/*" need = "system/bootmisc"
#ifd ubuntu
	iset -s "net/*" use = "system/ifupdown-debian"
#elsed debian linspire
	iset -s "net/*" need = "system/ifupdown-debian"
#endd
	iset -s "net/*" use = "system/modules system/coldplug daemon/cardmgr"
	iset -s "net/*" provide = "virtual/net virtual/net/${NAME}"
#ifd gentoo
	iset -s "net/*" exec start = "${INITNG_PLUGIN_DIR}/scripts/net/interface ${NAME} start"
	iset -s "net/*" exec stop = "${INITNG_PLUGIN_DIR}/scripts/net/interface ${NAME} stop"
#elsed arch
	iset -s "net/*" exec start = "/sbin/ifconfig ${NAME} up"
	iset -s "net/*" exec stop = "/sbin/ifconfig ${NAME} down"
#elsed enlisy
	iset -s "net/*" exec start = "/sbin/enlisy-net ${NAME} start"
	iset -s "net/*" exec stop = "/sbin/enlisy-net ${NAME} stop"
#endd

#ifd debian linspire pingwinek ubuntu
#ifd debian linspire ubuntu
	iexec -s "net/all" start = all_start
	iexec -s "net/all" stop = all_stop
#elsed pingwinek
	iexec -s "net/all" start = all_start
	iexec -s "net/all" stop = all_stop
#endd
#endd
#ifd gentoo
#elsed arch
#elsed enlisy
#elsed
	iexec -s "net/*" start = net_any_start
	iexec -s "net/*" stop = net_any_stop
#endd

#ifd debian linspire pingwinek ubuntu
	idone -s "net/all"
#endd
	idone -s "net/lo"
	idone -s "net/*"
}
#ifd debian linspire pingwinek ubuntu
#ifd debian linspire ubuntu

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
#endd
#ifd gentoo
#elsed arch
#elsed enlisy
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
