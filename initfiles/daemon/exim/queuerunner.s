# SERVICE: daemon/exim/queuerunner
# NAME:
# DESCRIPTION:
# WWW:

QUEUEINTERVAL="30m"
#ifd debian
[ -f /etc/defaults/exim4 ] && . /etc/defaults/exim4
#elsed gentoo
[ -f /etc/conf.d/exim ] && . /etc/conf.d/exim
#endd

setup()
{
	iregister daemon
		iset need = system/bootmisc virtual/net daemon/exim/updateconf
		iset conflict = daemon/exim/combined
		iexec daemon = "@/usr/sbin/exim4@ -q${QFLAGS}${QUEUEINTERVAL} ${COMMONOPTIONS} ${QUEUERUNNEROPTIONS}"
	idone
}
