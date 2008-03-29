# SERVICE; daemon/chronyd
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset pid_file = "/var/run/chronyd.pid"
		iset forks
		iset exec daemon = "@/usr/sbin/chronyd@ -f /etc/chrony/chrony.conf"
	idone
}
