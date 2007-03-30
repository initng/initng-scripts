# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="daemon/syslogd/prepare"
	iregister service
	iset need = "system/bootmisc"
	iexec start = prepare
	idone

	export SERVICE="daemon/syslogd"
	iregister daemon
	iset provide = "virtual/syslog"
#ifd debian
	iset need = "system/bootmisc daemon/syslogd/prepare"
#elsed
	iset need = "system/bootmisc"
	iset use = "daemon/syslogd/prepare"
#endd
	iset exec daemon = "@/sbin/syslogd@ -n -m 0"
	idone
}

prepare()
{
	if [ ! -e /dev/xconsole ]
	then
		mknod -m 640 /dev/xconsole p
	else
		chmod 0640 /dev/xconsole
	fi
	chown root:root /dev/xconsole
}
