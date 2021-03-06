# SERVICE: service/laptop-mode
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/bootmisc
		iexec start
		iexec stop
	idone
}

start() {
	# Run it with "force" so that syslog.conf and hdparm settings
	# are set correctly at system bootup.
	if [ ! -x @/usr/sbin/laptop_mode:/usr/sbin/laptop-mode@ ]; then
		echo "@/usr/sbin/laptop_mode:/usr/sbin/laptop-mode@ not found!"
		exit 1
	fi

	@touch@ /var/run/laptop-mode-enabled
	@/usr/sbin/laptop_mode:/usr/sbin/laptop-mode@ auto force >/dev/null
	exit 0
}

stop() {
	[ -e /var/run/laptop-mode-enabled ] || exit 0
	@rm@ -f /var/run/laptop-mode-enabled
	@/usr/sbin/laptop_mode:/usr/sbin/laptop-mode@ stop >/dev/null
}
