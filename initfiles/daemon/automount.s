# NAME: Autofs
# DESCRIPTION: kernel-based automounter for Linux
# WWW:

#ifd fedora
PIDFILE="/var/lock/subsys/autofs"
[ -f /etc/sysconfig/autofs ] && . /etc/sysconfig/autofs
#elsed
TIMEOUT="30"
[ -f /etc/conf.d/automount ] && . /etc/conf.d/automount
MOUNTPOINT="/mnt/${NAME}"
PIDFILE="/var/run/autofs.${NAME}.pid"
CONFFILE="/etc/autofs/auto.${NAME}"
#endd

setup()
{
#ifd fedora
	ireg daemon daemon/automount && {
#elsed
	[ "${SERVICE}" = daemon/automount ] && return 1

	# daemon/automount/*
	ireg daemon && {
#endd

#ifd fedora
		iset need = system/modules/autofs4
#elsed
		iset use = system/modules/autofs4
#endd
		iset need = system/bootmisc
		iset pid_file = "${PIDFILE}"
		iset forks

#ifd fedora
		iset exec daemon = "@automount@ --pid-file ${PIDFILE} ${OPTIONS}"
#elsed
		iset exec daemon = "@automount@ --timeout ${TIMEOUT} --pid-file ${PIDFILE} ${MOUNTPOINT} file ${CONFFILE}"
#endd
	}
}
