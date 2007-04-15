# NAME:
# DESCRIPTION:
# WWW:

spl_pidfile="/etc/splashy/splashy.pid"
spl_fifo="/etc/splashy/splashy.fifo"
[ -f /etc/default/splashy ] && . /etc/default/splashy
SPL_MSG="Starting ${NAME} boot sequence"

. /etc/init.d/splashy-functions.sh

setup()
{
	ireg service service/splashy/chvt && {
		iexec start = chvt
		return 0
	}

	ireg service service/splashy && {
		iset need = system/initial
		iexec start
		iexec stop
	}
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
