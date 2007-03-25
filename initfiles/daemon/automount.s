# NAME: Autofs
# DESCRIPTION: kernel-based automounter for Linux
# WWW:

#ifd fedora
PIDFILE="/var/lock/subsys/autofs"
source /etc/sysconfig/autofs
#elsed
TIMEOUT="30"
source /etc/conf.d/automount
MOUNTPOINT="/mnt/${NAME}"
PIDFILE="/var/run/autofs.${NAME}.pid"
CONFFILE="/etc/autofs/auto.${NAME}"
#endd

setup()
{
#ifd fedora
	iregister -s "daemon/automount" daemon
#elsed
	iregister -s "daemon/automount/*" daemon
#endd

#ifd fedora
	iset -s "daemon/automount" need = "system/modules/autofs4"
#elsed
	iset -s "daemon/automount/*" use = "system/modules/autofs4"
#endd
	iset -s "daemon/automount/*" need = "system/bootmisc"
	iset -s "daemon/automount/*" pid_file = "${PIDFILE}"
	iset -s "daemon/automount/*" forks

#ifd fedora
	iexec -s "daemon/automount/*" daemon = "@automount@ --pid-file ${PIDFILE} ${OPTIONS}"
#elsed
	iexec -s "daemon/automount/*" daemon = "@automount@ --timeout ${TIMEOUT} --pid-file ${PIDFILE} ${MOUNTPOINT} file ${CONFFILE}"
#endd

#ifd fedora
	idone -s "daemon/automount"
#elsed
	idone -s "daemon/automount/*"
#endd
}

