# SERVICE: service/splashy
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
	iregister service
		iset need = system/initial
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
