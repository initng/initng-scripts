# SERVICE: daemon/openvpn/prepare
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/bootmisc system/modules/tun
		iexec start
	idone
}

start()
{
	[ -h /dev/net/tun -a -c /dev/misc/net/tun ] || exit 0

	echo "Detected broken /dev/net/tun symlink, fixing..."
	@rm@ /dev/net/tun
	@ln@ -s /dev/misc/net/tun /dev/net/tun
}
