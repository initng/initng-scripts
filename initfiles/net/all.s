# SERVICE: net/all
# NAME:
# DESCRIPTION:
# WWW:

#ifd debian linspire pingwinek ubuntu
setup() {
	iregister service
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
		iexec start
		iexec stop
	idone
}

#ifd debian linspire ubuntu
start() {
	mkdir -p /var/run/network
	for i in $(@awk@ '$0~/^auto / { for (i=2; i<=NF; i++) print $i }' /etc/network/interfaces); do
		ngc --quiet -u net/${i} &
	done
	wait
}

stop() {
	for i in $(@awk@ '$0~/^auto / { for (i=2; i<=NF; i++) print $i }' /etc/network/interfaces); do
		ngc --quiet -d net/${i} &
	done
	wait
}
#elsed pingwinek
start() {
	/etc/net/scripts/initconf write
	/etc/net/scripts/network.init start
}

stop() {
	/etc/net/scripts/network.init stop
}
#endd
#endd
