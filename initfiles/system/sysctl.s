# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/initial"

	iexec start = sysctl_start

	idone
}

sysctl_start()
{
		if [ -d /etc/sysctl.d ]
		then
			for conf in /etc/sysctl.d/*.conf
			do
				@/sbin/sysctl@ -n -e -q -p "${conf}"
			done
		elif [ -f /etc/sysctl.conf ]
		then
			@/sbin/sysctl@ -n -e -q -p;
		else
			exit 1
		fi
}
