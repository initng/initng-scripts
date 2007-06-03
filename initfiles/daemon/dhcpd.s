# SERVICE: daemon/dhcpd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset exec daemon = "@/usr/sbin/dhcpd@ -f"
	idone
}
