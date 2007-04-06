# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/dhclient
	iset need = system/bootmisc
	iset use = system/modules system/coldplug
	iset stdout = "/var/log/dhclient.${NAME}"
	iset forks
	iset respawn
	iset exec daemon = "@/sbin/dhclient@ -d ${NAME}"
	idone
}
