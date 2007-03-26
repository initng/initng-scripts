# NAME:
# DESCRIPTION:
# WWW:

COMMONOPTIONS=""""
QUEUERUNNEROPTIONS=""""
QFLAGS=""""
SMTPLISTENEROPTIONS=""""
QUEUEINTERVAL="30m"
QRPIDFILE="/var/run/exim4/eximqr.pid"
#ifd debian
source /etc/defaults/exim4
#elsed gentoo
source /etc/conf.d/exim
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net daemon/exim/updateconf"
	iset conflict = "daemon/exim/combined"
	iset pid_file = "${QRPIDFILE}"
	iset forks

	iset exec daemon = "@/usr/sbin/exim4@ -oP "${QRPIDFILE}" -q${QFLAGS}${QUEUEINTERVAL} ${COMMONOPTIONS} ${QUEUERUNNEROPTIONS}"

	idone
}

