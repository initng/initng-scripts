# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/netdaemon && {
		iset need = system/bootmisc
		iset use = system/coldplug system/modules
		iset pid_of = netdaemon
		iset exec daemon = "@/usr/sbin/netdaemon@"
	}
}
