# NAME:
# DESCRIPTION:
# WWW:

spl_pidfile="/etc/splashy/splashy.pid"
spl_fifo="/etc/splashy/splashy.fifo"
source /etc/default/splashy
SPL_MSG="Starting ${NAME} boot sequence"

source /etc/init.d/splashy-functions.sh

setup()
{
	export SERVICE="service/splashy/chvt"
	iregister service
	iexec start = chvt
	idone

	export SERVICE="service/splashy"
	iregister service
	iset need = "system/initial"
	iexec start
	iexec stop
	idone
}

start()
{
	[ -x @/sbin/splashy@ ] || exit 0
	@start-stop-daemon@ --start --quiet --pidfile ${spl_pidfile} --exec @/sbin/splashy@ -- boot 2>/dev/null
	exec @/sbin/ngc@ -S "splashy,boot"
}

stop()
{
	[ -x @/sbin/splashy@ ] || exit 0
	@start-stop-daemon@ --start --quiet --pidfile ${spl_pidfile} --exec ${DAEMON} -- boot 2> /dev/null
	exec @/sbin/ngc@ -S "splashy,shutdown"
}

chvt()
{
	x_vt=""
	for i in `@seq@ 0 10`
	do
		x_vt=`ps -C X -o args= | @sed@ 's/.* vt\([0-9]*\).*/\1/g'`
		[ ! -z "${x_vt}" ] && break
		sleep .2
	done
	[ "${x_vt}" -gt 0 ] && exit 0
	exec @/usr/bin/chvt@ ${x_vt}
}
