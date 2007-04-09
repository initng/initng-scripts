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

[ -f /etc/conf.d/distccd ] && . /etc/conf.d/distccd

setup()
{
	ireg daemon daemon/distccd
	iset need = system/bootmisc virtual/net
	iset suid = distcc
#ifd gentoo
	iset pid_file = "${DISTCCD_PIDFILE}"
#elsed
	iset pid_file = "${PIDFILE}"
#endd
	iset forks
	iexec daemon
	idone
}

daemon()
{
#ifd gentoo
	exec /usr/bin/distccd -N ${DISTCCD_NICE} --pid-file ${DISTCCD_PIDFILE} \
	                      ${DISTCCD_OPTS}
#elsed
	exec @/usr/bin/distccd@ -N ${NICE} --pid-file ${PIDFILE} --port ${PORT} \
	                        --allow ${ALLOW} --listen ${LISTEN}
#endd
}
