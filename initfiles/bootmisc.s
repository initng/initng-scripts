#!/sbin/runiscript

setup()
{
	# register new service type, the $SERVICE will be "example" here.
    iregister service

    iset need = "initial mountfs"
	iset use = "hdparm swap clock"

	iexec start	
	
	# Tell initng this service is done parsing.
    idone
}

start()
{
		# Setup login records
		echo -n "" > /var/run/utmp
		/usr/bin/touch /var/log/wtmp >/dev/null 2>&1
		/bin/chgrp utmp /var/run/utmp /var/log/wtmp >/dev/null 2>&1
		/bin/chmod 0664 /var/run/utmp /var/log/wtmp >/dev/null 2>&1
		# Remove /var/run/utmpx (bug from the past)
		/bin/rm -f /var/run/utmpx >/dev/null 2>&1

		#
		# Clean up /tmp directory
		#
		/bin/rm -f /tmp/.X*-lock /tmp/esrv* /tmp/kio* /tmp/jpsock.* /tmp/.fam* 2>&1 >/dev/null &
		/bin/rm -rf /tmp/.esd* /tmp/orbit-* /tmp/ssh-* /tmp/ksocket-* 2>&1 >/dev/null &
		# Make sure our X11 stuff have the correct permissions
		/bin/rm -rf /tmp/.*-unix
		/bin/mkdir -p /tmp/.ICE-unix /tmp/.X11-unix
		/bin/chmod 1777 /tmp/.???-unix 2>&1 >/dev/null &

		#
		# Clean up /var/lock and /var/run
		#
		/usr/bin/find /var/run/ ! -type d ! -name utmp ! -name innd.pid ! -name random-seed -exec /bin/rm \{\} \;
		/usr/bin/find /var/lock -type f -exec /bin/rm \{\} \;

		#
		# Create an 'after-boot' dmesg log
		#
		/usr/bin/touch /var/log/dmesg >/dev/null &
		/bin/chmod 640 /var/log/dmesg >/dev/null &
		/bin/dmesg >/var/log/dmesg &

		#
		# Check for /etc/resolv.conf, and create if missing
		#
		[ -f /etc/resolv.conf ] || /usr/bin/touch /etc/resolv.conf 2>&1 >/dev/null &

		wait
		exit 0
}
