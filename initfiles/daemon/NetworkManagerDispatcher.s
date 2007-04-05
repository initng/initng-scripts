# NAME:
# DESCRIPTION:
# WWW:

PID_FILE="/var/run/NetworkManager/NetworkManagerDispatcher.pid"

setup()
{
	ireg daemon daemon/NetworkManagerDispatcher
	iset need = system/bootmisc daemon/dbus daemon/NetworkManager
	iset pid_file = "${PID_FILE}"
	iset forks
	iset exec daemon = "@/usr/sbin/NetworkManagerDispatcher@ --pid-file"
	idone
}
