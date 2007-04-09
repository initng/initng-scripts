# NAME: HAL
# DESCRIPTION: Hardware Abstraction Layer
# WWW: http://www.freedesktop.org/Software/hal

#ifd debian
	PIDDIR="/var/run/hal"
	DAEMONUSER="hal"
	. /etc/default/hal
#elsed gentoo
	PIDDIR="/var/run"
#endd

setup()
{
	ireg daemon daemon/hald
	iset need = system/bootmisc daemon/dbus
	iset use = daemon/acpid
	iset stdall = "/dev/null"
	iset forks
#ifd debian gentoo
	iset pid_file = "${PIDDIR}/hald.pid"
#endd
	iexec daemon
	idone
}


daemon()
{
#ifd debian
	if [ ! -d ${PIDDIR} ]
	then
		@mkdir@ -p ${PIDDIR}
		chown ${DAEMONUSER}:${DAEMONUSER} ${PIDDIR}
	fi

	@/usr/sbin/hald@ ${DAEMON_OPTS}

#elsed gentoo
	if @/usr/sbin/hald@ --help | grep -qw -- "--use-syslog"
	then
		exec @/usr/sbin/hald@ --use-syslog
	else
		exec @/usr/sbin/hald@
	fi
#elsed
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
#endd
}
