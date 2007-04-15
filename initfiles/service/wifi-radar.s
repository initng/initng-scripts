# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service service/wifi-radar && {
		iset need = system/bootmisc
		iset use = system/modules system/coldplug
		iset stdall = "/var/log/wifi-radar.log"
		iset exec start = "@/usr/sbin/wifi-radar@ -d"
	}
}
