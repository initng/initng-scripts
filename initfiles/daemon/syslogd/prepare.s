# SERVICE: daemon/syslogd/prepare
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister task
		iset need = system/bootmisc
		iset once
		iexec task
	idone
}

task()
{
	if [ ! -e /dev/xconsole ]; then
		mknod -m 640 /dev/xconsole p
	else
		chmod 0640 /dev/xconsole
	fi
	chown root:root /dev/xconsole
}
