# NAME: distcc
# DESCRIPTION: Distributed compiler daemon
# WWW: http://distcc.samba.org/

#ifd gentoo
	DISTCCD_PIDFILE="/var/run/distccd/distccd.pid"
	DISTCCD_NICE="10"
	DISTCCD_OPTS="--port 3632 --log-level critical --allow 192.168.1.0/24"
#elsed
	PIDFILE="/var/run/distccd/distccd.pid"
	PORT="3632"
	ALLOW="192.168.0.0/24"
	LISTEN="0.0.0.0"
	NICE="10"
#endd

source /etc/conf.d/distccd

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net"
	iset suid = distcc
#ifd gentoo
	iset pid_file = "${DISTCCD_PIDFILE}"
#elsed
	iset pid_file = "${PIDFILE}"
#endd
	iset forks

#ifd gentoo
	iset exec daemon = "/usr/bin/distccd -N ${DISTCCD_NICE} --pid-file ${DISTCCD_PIDFILE} ${DISTCCD_OPTS}"
#elsed
	iset exec daemon = "@/usr/bin/distccd@ -N ${NICE} --pid-file ${PIDFILE} --port ${PORT} --allow ${ALLOW} --listen ${LISTEN}"
#endd

	idone
}
