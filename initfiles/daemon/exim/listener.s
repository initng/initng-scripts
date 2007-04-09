# NAME:
# DESCRIPTION:
# WWW:

#ifd debian
. /etc/defaults/exim4
#elsed gentoo
. /etc/conf.d/exim
#endd

setup()
{
	ireg daemon daemon/exim/listener
	iset need = system/bootmisc virtual/net daemon/exim/updateconf
	iset conflict = daemon/exim/combined
	iset provide = virtual/mta
	iset pid_file = "/var/run/exim4/exim.pid"
	iexec daemon
	idone
}

daemon()
{
	exec @/usr/sbin/exim4@ -bdf "${SMTPLISTENEROPTIONS}" "${COMMONOPTIONS}"
}
