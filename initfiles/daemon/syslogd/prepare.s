# SERVICE: daemon/syslogd/prepare
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/bootmisc
		iexec start
	idone
}

start() {
	if [ ! -e /dev/xconsole ]; then
		mknod -m 640 /dev/xconsole p
	else
		chmod 0640 /dev/xconsole
	fi
	chown root:root /dev/xconsole
}
