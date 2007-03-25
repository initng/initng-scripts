# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister -s "daemon/openvpn/*" daemon
	iregister -s "daemon/openvpn/prepare" service
	iregister -s "daemon/openvpn" service

	iset -s "daemon/openvpn/*" need = "system/bootmisc virtual/net"
	iset -s "daemon/openvpn/prepare" need = "system/bootmisc system/modules/tun"
	iset -s "daemon/openvpn" need = "system/bootmisc system/modules/tun"

	iexec -s "daemon/openvpn/*" daemon = "@/usr/sbin/openvpn@ --config /etc/openvpn/${NAME}/local.conf --writepid /var/run/openvpn-${NAME}.pid --cd /etc/openvpn/${NAME}"
	iexec -s "daemon/openvpn/prepare" start = prepare_start
	iexec -s "daemon/openvpn" start = openvpn_start
	iexec -s "daemon/openvpn" stop = openvpn_stop

	idone -s "daemon/openvpn/*"
	idone -s "daemon/openvpn/prepare"
	idone -s "daemon/openvpn"
}

prepare_start()
{
		if [ -h /dev/net/tun -a -c /dev/misc/net/tun ]
		then
			echo "Detected broken /dev/net/tun symlink, fixing..."
			@rm@ /dev/net/tun
			@ln@ -s /dev/misc/net/tun /dev/net/tun
		fi
}

openvpn_start()
{
		if [ ! -d /etc/openvpn ]
		then
			echo "Cant find openvpn conf dir! ..."
			exit 1
		fi
	
		cd /etc/openvpn
		for VPN in *
		do
			[ -e ${VPN}/local.conf ] && @/sbin/ngc@ --quiet -u daemon/openvpn/${VPN} &
		done
		wait
		exit 0
}

openvpn_stop()
{
		cd /etc/openvpn
		for VPN in *
		do
			[ -e ${VPN}/local.conf ] && @/sbin/ngc@ --quiet -d daemon/openvpn/${VPN} &
		done
		wait
		exit 0
}
