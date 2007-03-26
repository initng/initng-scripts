# NAME: HAL
# DESCRIPTION: Hardware Abstraction Layer
# WWW: http://www.freedesktop.org/Software/hal

#ifd debian
PIDDIR="/var/run/hal"
DAEMONUSER="hal"
source /etc/default/hal
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc daemon/dbus"
	iset use = "daemon/acpid"
	iset stdall = /dev/null
	iset forks
#ifd debian
	iset pid_file = "${PIDDIR}/hald.pid"
	iset forks
#elsed gentoo
	iset pid_file = "/var/run/hald.pid"
	iset pid_file = "/var/run/hald/hald.pid"
#endd

#ifd debian
	iset exec daemon = hald_daemon
#elsed gentoo
	iset exec daemon = hald_daemon
#elsed
	iset exec daemon = hald_daemon
#endd

	idone
}

#ifd debian
hald_daemon()
{
		if [ ! -d ${PIDDIR} ]
		then
			@mkdir@ -p ${PIDDIR}
			chown ${DAEMONUSER}:${DAEMONUSER} ${PIDDIR}
		fi
		@/usr/sbin/hald@ ${DAEMON_OPTS}
}
#elsed gentoo

hald_daemon()
{
		if @/usr/sbin/hald@ --help | grep -qw -- "--use-syslog"
		then
			exec @/usr/sbin/hald@ --use-syslog
		else
			exec @/usr/sbin/hald@			
		fi
}
#elsed

hald_daemon()
{
		# Make sure, there is no stale processes running.
		killall hald
		killall -9 hald

		# Clear pid file.
		@rm@ /var/run/hal/pid

		# We have to probe what version it is, they use different arguments.
		if @/usr/sbin/hald@ --help 2>&1 | @grep@ -- --retain-privileges
		then
			exec @/usr/sbin/hald@ --daemon=no --retain-privileges
		elif @/usr/sbin/hald@ --help 2>&1 | @grep@ -- --drop-privileges
		then
			exec @/usr/sbin/hald@ --daemon=no --drop-privileges
		else
			exec @/usr/sbin/hald@ --daemon=no
		fi
		exit 1
}
#endd
