# NAME:
# DESCRIPTION:
# WWW:

COMMONOPTIONS=""""
QUEUERUNNEROPTIONS=""""
QFLAGS=""""
SMTPLISTENEROPTIONS=""""
QUEUEINTERVAL="30m"
#ifd debian
source /etc/defaults/exim4
#elsed gentoo
source /etc/conf.d/exim
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net daemon/exim/updateconf"
	iset conflict = "daemon/exim/queuerunner daemon/exim/listner"
	iset provide = "virtual/mta"
	iset pid_file = "/var/run/exim4/exim.pid"

	iset exec daemon = "@/usr/sbin/exim4@ -bdf -q${QFLAGS}${QUEUEINTERVAL} ${COMMONOPTIONS} ${QUEUERUNNEROPTIONS} ${SMTPLISTENEROPTIONS}"

	idone
}

