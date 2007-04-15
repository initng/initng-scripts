# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service daemon/syslogd/prepare && {
		iset need = system/bootmisc
		iexec start = prepare
		return 0
	}

	ireg daemon daemon/syslogd && {
		iset provide = virtual/syslog
		iset need = system/bootmisc
#ifd debian
		iset need = daemon/syslogd/prepare
#elsed
		iset use = daemon/syslogd/prepare
#endd
		iset exec daemon = "@/sbin/syslogd@ -n -m 0"
	}
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
