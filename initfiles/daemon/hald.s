# SERVICE: daemon/hald
# NAME: HAL
# DESCRIPTION: Hardware Abstraction Layer
# WWW: http://www.freedesktop.org/Software/hal

#ifd debian
PIDDIR="/var/run/hal"
DAEMONUSER="hal"
[ -f /etc/default/hal ] && . /etc/default/hal
#elsed gentoo
PIDDIR="/var/run"
#endd

setup()
{
	iregister daemon
		iset need = system/bootmisc daemon/dbus
		iset use = daemon/acpid
		iset stdall = "/dev/null"
#ifd debian gentoo
		iset pid_file = "${PIDDIR}/hald.pid"
		iset forks
#endd
		iexec daemon
	idone
}


daemon()
{
#ifd debian
	if [ ! -d ${PIDDIR} ]; then
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

	exec @/usr/sbin/hald@ --daemon=no
	exit 1
#endd
}
