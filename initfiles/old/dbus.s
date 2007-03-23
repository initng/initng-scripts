#!/sbin/runiscript

DAEMONUSER=messagebus
PIDDIR=/var/run/dbus
DAEMONUSER=messagebus
PIDFILE=${PIDDIR}/pid

#ifd debian pingwinek
source /etc/default/dbus
#endd

setup()
{
    iregister daemon
    iset need = bootmisc
	iset forks
#ifd fedora altlinux
	set pid_file = /var/run/messagebus.pid
#elsed debian pingwinek
	set pid_file = /var/run/dbus/pid
#elsed
	set pid_file = /var/run/dbus.pid
#endd
	
	iexec daemon
    idone
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
#elsed
daemon()
{
	exec @/bin/dbus-daemon:/usr/bin/dbus-daemon:/usr/bin/dbus-daemon-1@ --system --fork
}
#endd
