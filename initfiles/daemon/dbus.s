# SERVICE: daemon/dbus
# NAME: D-Bus
# DESCRIPTION: Application communication framework
# WWW: http://dbus.freedesktop.org/

#ifd debian pingwinek
[ -f /etc/default/dbus ] && . /etc/default/dbus
#elsed
PIDFILE=/var/run/dbus.pid
#endd

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset forks
		iset pid_file = "${PIDFILE}"
#ifd debian
		iexec daemon
#elsed
		iset exec daemon = "@/bin/dbus-daemon:/usr/bin/dbus-daemon:/usr/bin/dbus-daemon-1@ --system --nofork"
#endd
	idone
}

#ifd debian
daemon() {
	[ "${ENABLED}" = 0 ] && exit 0
	exec /usr/bin/dbus-daemon --system ${PARAMS} --nofork
}
#endd
