# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/dhcpd && {
		iset need = system/bootmisc
		iset exec daemon = "@/usr/sbin/dhcpd@ -f"
	}
}
