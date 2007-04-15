# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	[ "${SERVICE}" = net/ppp ] && return 1

	ireg daemon && {
		iset need = system/bootmisc system/modules
		iset use = system/coldplug daemon/bluetooth/rfcomm
		iset exec daemon = "@/usr/sbin/pppd@ call $NAME nodetach"
	}
}
