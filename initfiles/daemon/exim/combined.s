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
	ireg daemon daemon/exim/combined && {
		iset need = system/bootmisc virtual/net daemon/exim/updateconf
		iset conflict = daemon/exim/{queuerunner,listner}
		iset provide = virtual/mta
		iset pid_file = "/var/run/exim4/exim.pid"
		iset exec daemon = "@/usr/sbin/exim4@ -bdf -q${QFLAGS}${QUEUEINTERVAL} ${COMMONOPTIONS} ${QUEUERUNNEROPTIONS} ${SMTPLISTENEROPTIONS}"
	}
}
