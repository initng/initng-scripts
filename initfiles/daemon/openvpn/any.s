# SERVICE: daemon/openvpn/*
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset exec daemon = "@/usr/sbin/openvpn@ --config /etc/openvpn/${NAME}/local.conf --writepid /var/run/openvpn-${NAME}.pid --cd /etc/openvpn/${NAME}"
	idone
}
