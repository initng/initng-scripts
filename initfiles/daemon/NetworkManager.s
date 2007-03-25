# NAME: 
# DESCRIPTION: 
# WWW: 

PID_FILE =" /var/run/NetworkManager/NetworkManager.pid"

setup()
{
	iregister -s "daemon/NetworkManager/prepare" service
	iregister -s "daemon/NetworkManager" daemon

	iset -s "daemon/NetworkManager/prepare" need = "system/bootmisc"
	iset -s "daemon/NetworkManager" need = "system/bootmisc daemon/dbus daemon/NetworkManager/prepare system/modules/capability daemon/hald daemon/dhcdbd"
	iset -s "daemon/NetworkManager" provide = "virtual/net"
	iset -s "daemon/NetworkManager" pid_file = "${PID_FILE}"
	iset -s "daemon/NetworkManager" forks

	iexec -s "daemon/NetworkManager/prepare" start = prepare_start
	iexec -s "daemon/NetworkManager" daemon = "@/usr/sbin/NetworkManager@ --pid-file"

	idone -s "daemon/NetworkManager/prepare"
	idone -s "daemon/NetworkManager"
}

prepare_start()
{
		[ -d /var/lib/NetworkManager ] || @/bin/mkdir@ -p /var/lib/NetworkManager
		chmod 755 /var/lib/NetworkManager
		[ -d /var/run/NetworkManager ] || @/bin/mkdir@ -p /var/run/NetworkManager
		chmod 755 /var/run/NetworkManager
}
