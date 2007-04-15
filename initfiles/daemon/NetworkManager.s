# NAME:
# DESCRIPTION:
# WWW:

PID_FILE="/var/run/NetworkManager/NetworkManager.pid"

setup()
{
	ireg service daemon/NetworkManager/prepare && {
		iset need = system/bootmisc
		iexec start = prepare_start
		return 0
	}

	ireg daemon daemon/NetworkManager && {
		iset need = system/bootmisc daemon/dbus daemon/NetworkManager/prepare \
		            system/modules/capability daemon/hald daemon/dhcdbd
		iset provide = virtual/net
		iset pid_file = "${PID_FILE}"
		iset forks
		iset exec daemon = "@/usr/sbin/NetworkManager@ --pid-file=${PID_FILE}"
	}
}

prepare_start()
{
	[ -d /var/lib/NetworkManager ] ||
		@/bin/mkdir@ -p /var/lib/NetworkManager
	[ -d /var/run/NetworkManager ] ||
		@/bin/mkdir@ -p /var/run/NetworkManager
	chmod 755 /var/lib/NetworkManager
	chmod 755 /var/run/NetworkManager
}
