# SERVICE: daemon/automount/*
# NAME: Autofs
# DESCRIPTION: kernel-based automounter for Linux
# WWW:

TIMEOUT="30"
[ -f /etc/conf.d/automount ] && . /etc/conf.d/automount
MOUNTPOINT="/mnt/${NAME}"
PIDFILE="/var/run/autofs.${NAME}.pid"
CONFFILE="/etc/autofs/auto.${NAME}"

setup() {
	iregister daemon
		iset use = system/modules/autofs4
		iset need = system/bootmisc
		iset pid_file = "${PIDFILE}"
		iset forks
		iset exec daemon = "@automount@ --timeout ${TIMEOUT} --pid-file ${PIDFILE} ${MOUNTPOINT} file ${CONFFILE}"
	idone
}
