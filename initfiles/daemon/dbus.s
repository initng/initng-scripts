# NAME: D-Bus
# DESCRIPTION: Application communication framework
# WWW: http://dbus.freedesktop.org/

#ifd fedora altlinux mandriva
#elsed debian pingwinek
DAEMONUSER="messagebus"
PIDDIR =" /var/run/dbus"
PIDFILE =" ${PIDDIR}/pid"
source /etc/default/dbus
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset forks
#ifd fedora altlinux mandriva
	iset pid_file = "/var/run/messagebus.pid"
#elsed debian pingwinek
	iset pid_file = "${PIDFILE}"
#elsed
	iset pid_file = "/var/run/dbus.pid"
#endd

#ifd debian
	iexec daemon = dbus_daemon
#elsed
	iexec daemon = "@/bin/dbus-daemon:/usr/bin/dbus-daemon:/usr/bin/dbus-daemon-1@ --system --fork"
#endd

	idone
}

#ifd debian
dbus_daemon()
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
