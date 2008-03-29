# SERVICE: daemon/powersaved
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc system/modules daemon/dbus \
	        	    daemon/powersaved/prepare daemon/acpid daemon/hald
		iset pid_file = "/var/run/powersaved.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/powersaved@ -d -f /var/run/acpid.socket"
	idone
}
