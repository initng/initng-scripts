# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/bluetooth/hcid
	iset need = system/bootmisc daemon/dbus
	iset use = system/coldplug system/modules/depmod
	iset stdall = /dev/null
	iset pid_of = hcid
	iset respawn
	iset exec daemon = "@/usr/sbin/hcid@ -f /etc/bluetooth/hcid.conf"
	idone
}
