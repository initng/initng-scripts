# NAME:
# DESCRIPTION:
# WWW:

COMMONOPTIONS=""""
SMTPLISTENEROPTIONS=""""
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
	iset provide = "virtual/mta"
	iset pid_file = "/var/run/exim4/exim.pid"

	iexec daemon = "@/usr/sbin/exim4@ -bdf ${SMTPLISTENEROPTIONS} ${COMMONOPTIONS}"

	idone
}

