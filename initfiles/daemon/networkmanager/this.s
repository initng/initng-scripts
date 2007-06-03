# SERVICE: daemon/networkmanager
# NAME:
# DESCRIPTION:
# WWW:

PID_FILE="/var/run/NetworkManager/NetworkManager.pid"

setup()
{
	iregister daemon
		iset need = system/bootmisc daemon/dbus \
		            daemon/networkmanager/prepare
		            system/modules/capability daemon/hald \
		            daemon/dhcdbd
		iset provide = virtual/net
		iset pid_file = "$PID_FILE"
		iset forks
		iset exec daemon = "@/usr/sbin/NetworkManager@ --pid-file=$PID_FILE"
	idone
}
