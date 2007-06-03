# SERVICE: daemon/openvpn/prepare
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister task
		iset need = system/bootmisc system/modules/tun
		iset once
		iexec task
	idone
}

task()
{
	[ -h /dev/net/tun -a -c /dev/misc/net/tun ] || exit 0

	echo "Detected broken /dev/net/tun symlink, fixing..."
	@rm@ /dev/net/tun
	@ln@ -s /dev/misc/net/tun /dev/net/tun
}
