# SERVICE: daemon/networkmanager/prepare
# NAME:
# DESCRIPTION:
# WWW:

PID_FILE="/var/run/NetworkManager/NetworkManager.pid"

setup()
{
	iregister task
		iset need = system/bootmisc
		iset once
		iexec task
	idone
}

task()
{
	[ -d /var/lib/NetworkManager ] ||
		@/bin/mkdir@ -p /var/lib/NetworkManager
	[ -d /var/run/NetworkManager ] ||
		@/bin/mkdir@ -p /var/run/NetworkManager
	chmod 755 /var/lib/NetworkManager
	chmod 755 /var/run/NetworkManager
}
