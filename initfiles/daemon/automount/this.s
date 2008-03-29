# SERVICE: daemon/automount
# NAME: Autofs
# DESCRIPTION: kernel-based automounter for Linux
# WWW:

#ifd fedora
PIDFILE="/var/lock/subsys/autofs"
[ -f /etc/sysconfig/autofs ] && . /etc/sysconfig/autofs

setup() {
	iregister daemon
		iset need = system/modules/autofs4
		iset need = system/bootmisc
		iset pid_file = "${PIDFILE}"
		iset forks
		iset exec daemon = "@automount@ --pid-file ${PIDFILE} ${OPTIONS}"
	idone
}
#endd
