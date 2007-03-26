# NAME: 
# DESCRIPTION: 
# WWW: 

spl_pidfile="/etc/splashy/splashy.pid"
spl_fifo="/etc/splashy/splashy.fifo"
source /etc/default/splashy
SPL_MSG="Starting ${NAME} boot sequence"

setup()
{
	iregister -s "service/splashy" service
	iregister -s "service/splashy/chvt" service

	iset -s "service/splashy" need = "system/initial"

	iexec -s "service/splashy" start = splashy_start
	iexec -s "service/splashy" stop = splashy_stop
	iexec -s "service/splashy/chvt" start = chvt_start

	idone -s "service/splashy"
	idone -s "service/splashy/chvt"
}

splashy_start()
{
		[ -x @/sbin/splashy@ ] || exit 0
		. /etc/init.d/splashy-functions.sh
		@start-stop-daemon@ --start --quiet --pidfile ${spl_pidfile} --exec @/sbin/splashy@ -- boot 2>/dev/null
		exec @/sbin/ngc@ -S "splashy,boot"
}

splashy_stop()
{
		[ -x @/sbin/splashy@ ] || exit 0
		. /etc/init.d/splashy-functions.sh
		@start-stop-daemon@ --start --quiet --pidfile ${spl_pidfile} --exec ${DAEMON} -- boot 2> /dev/null
		exec @/sbin/ngc@ -S "splashy,shutdown"
}

chvt_start()
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
