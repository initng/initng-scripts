# SERVICE: daemon/openvpn
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/bootmisc system/modules/tun
		iexec start
		iexec stop
	idone
}

start()
{
	if [ ! -d /etc/openvpn ]; then
		echo "Cant find openvpn conf dir! ..."
		exit 1
	fi

	cd /etc/openvpn
	for VPN in *; do
		[ -e ${VPN}/local.conf ] &&
		@/sbin/ngc@ --instant --quiet -u daemon/openvpn/${VPN} &
	done
	wait
	exit 0
}

stop()
{
	cd /etc/openvpn
	for VPN in *; do
		[ -e ${VPN}/local.conf ] &&
		@/sbin/ngc@ --instant --quiet -d daemon/openvpn/${VPN} &
	done
	wait
	exit 0
}
