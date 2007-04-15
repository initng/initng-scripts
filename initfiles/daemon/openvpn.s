# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service daemon/openvpn/prepare && {
		iset need = system/bootmisc system/modules/tun
		iexec start = prepare_start
		return 0
	}

	ireg service daemon/openvpn && {
		iset need = system/bootmisc system/modules/tun
		iexec start
		iexec stop
		return 0
	}

	# daemon/openvpn/*
	ireg daemon && {
		iset need = system/bootmisc virtual/net
		iset exec daemon = "@/usr/sbin/openvpn@ --config /etc/openvpn/${NAME}/local.conf --writepid /var/run/openvpn-${NAME}.pid --cd /etc/openvpn/${NAME}"
	}
}

prepare_start()
{
	[ -h /dev/net/tun -a -c /dev/misc/net/tun ] || exit 0

	echo "Detected broken /dev/net/tun symlink, fixing..."
	@rm@ /dev/net/tun
	@ln@ -s /dev/misc/net/tun /dev/net/tun
}

start()
{
	if [ ! -d /etc/openvpn ]
	then
		echo "Cant find openvpn conf dir! ..."
		exit 1
	fi

	cd /etc/openvpn
	for VPN in *
	do
		[ -e ${VPN}/local.conf ] && @/sbin/ngc@ --instant --quiet -u daemon/openvpn/${VPN} &
	done
	wait
	exit 0
}

stop()
{
	cd /etc/openvpn
	for VPN in *
	do
		[ -e ${VPN}/local.conf ] && @/sbin/ngc@ --instant --quiet -d daemon/openvpn/${VPN} &
	done
	wait
	exit 0
}
