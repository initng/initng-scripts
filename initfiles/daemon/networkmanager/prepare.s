# SERVICE: daemon/networkmanager/prepare
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/bootmisc
		iexec start
	idone
}

start()
{
	[ -d /var/lib/NetworkManager ] ||
		@/bin/mkdir@ -p /var/lib/NetworkManager
	[ -d /var/run/NetworkManager ] ||
		@/bin/mkdir@ -p /var/run/NetworkManager
	chmod 755 /var/lib/NetworkManager
	chmod 755 /var/run/NetworkManager
}
