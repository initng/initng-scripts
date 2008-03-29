# SERVICE: daemon/hald
# NAME: HAL
# DESCRIPTION: Hardware Abstraction Layer
# WWW: http://www.freedesktop.org/Software/hal

#ifd debian
[ -f /etc/default/hal ] && . /etc/default/hal
#endd

setup() {
	iregister daemon
		iset need = system/bootmisc daemon/dbus
		iset use = daemon/acpid
		iset stdall = "/dev/null"
		iexec daemon
	idone
}


daemon() {
#ifd gentoo
	@/usr/sbin/hald@ --help | grep -qw -- "--use-syslog" &&
	DAEMON_OPTS="--use-syslog"
#endd
	exec @/usr/sbin/hald@ ${DAEMON_OPTS} --daemon=no
}
