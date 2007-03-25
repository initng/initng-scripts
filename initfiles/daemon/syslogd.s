# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister -s "daemon/syslogd/prepare" service
	iregister -s "daemon/syslogd" daemon

	iset -s "daemon/syslogd/prepare" need = "system/bootmisc"
	iset -s "daemon/syslogd" provide = "virtual/syslog"
#ifd debian
	iset -s "daemon/syslogd" need = "system/bootmisc daemon/syslogd/prepare"
#elsed
	iset -s "daemon/syslogd" need = "system/bootmisc"
	iset -s "daemon/syslogd" use = "daemon/syslogd/prepare"
#endd

	iexec -s "daemon/syslogd/prepare" start = prepare_start
	iexec -s "daemon/syslogd" daemon = "@/sbin/syslogd@ -n -m 0"

	idone -s "daemon/syslogd/prepare"
	idone -s "daemon/syslogd"
}

prepare_start()
{
		if [ ! -e /dev/xconsole ]
		then
			mknod -m 640 /dev/xconsole p
		else
			chmod 0640 /dev/xconsole
		fi
		chown root:root /dev/xconsole	    
}
