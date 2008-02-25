# SERVICE: daemon/dhclient
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset use = system/modules system/coldplug
		iset stdout = "/var/log/dhclient.${NAME}"
		iset respawn
		iset exec daemon = "@/sbin/dhclient@ -d ${NAME}"
	idone
}
