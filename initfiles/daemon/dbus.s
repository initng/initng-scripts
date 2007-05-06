# NAME: D-Bus
# DESCRIPTION: Application communication framework
# WWW: http://dbus.freedesktop.org/

#ifd debian pingwinek
DAEMONUSER="messagebus"
[ -f /etc/default/dbus ] && . /etc/default/dbus
#endd

#ifd fedora altlinux mandriva
PIDFILE="/var/run/messagebus.pid"
#elsed debian pingwinek sourcemage
PIDFILE="/var/run/dbus/pid"
#elsed
PIDFILE="/var/run/dbus.pid"
#endd

setup()
{
	ireg daemon daemon/dbus && {
		iset need = system/bootmisc
		iset forks
		iset pid_file = "${PIDFILE}"
#ifd debian
		iexec daemon
#elsed
		iset exec daemon = "@/bin/dbus-daemon:/usr/bin/dbus-daemon:/usr/bin/dbus-daemon-1@ --system --fork"
#endd
	}
}

#ifd debian
daemon()
{
	[ "${ENABLED}" = 0 ] && exit 0
	#Debian and Ubuntu are using different files
	DAEMON=/usr/bin/dbus-daemon

	if [ ! -d ${PIDDIR} ]
	then
		@mkdir@ -p ${PIDDIR}
		chown ${DAEMONUSER} ${PIDDIR}
		chgrp ${DAEMONUSER} ${PIDDIR}
	fi
	if [ -e ${PIDFILE} ]
	then
		PIDDIR=/proc/`@cat@ ${PIDFILE}`
		if [ -d ${PIDDIR} -a  "`readlink -f ${PIDDIR}/exe`" = "${DAEMON}" ]
		then
			echo "${DESC} already started; not starting."
		else
			echo "Removing stale PID file ${PIDFILE}."
			@rm@ -f ${PIDFILE}
		fi
	fi

	exec ${DAEMON} --system ${PARAMS}
}
#endd
