#!/sbin/runiscript

#ifd debian
	PIDDIR=/var/run/hal
	DAEMONUSER=hal
	source /etc/default/hal
#endd

setup()
{
    iregister daemon
    iset need = "bootmisc dbus"
	iset use = acpid
	iset forks
	iexec daemon

#ifd debian
	iset pid_file = "${PIDDIR}/hald.pid"
#endd

#ifd gentoo
	iset pid_file = /var/run/hald.pid /var/run/hald/hald.pid
#endd
    idone
}

#ifd debian
daemon()
{
	if [ ! -d ${PIDDIR} ]
	then
		@mkdir@ -p ${PIDDIR}
		chown ${DAEMONUSER}:${DAEMONUSER} ${PIDDIR}
	fi
	exec @/usr/sbin/hald@ ${DAEMON_OPTS}
}
#elsed gentoo
daemon ()
{
	if @/usr/sbin/hald@ --help | grep -qw -- "--use-syslog"
	then
		exec @/usr/sbin/hald@ --use-syslog
	else
		exec @/usr/sbin/hald@			
	fi
}

#elsed
daemon()
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