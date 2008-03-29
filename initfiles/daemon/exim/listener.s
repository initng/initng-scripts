# SERVICE: daemon/exim/listener
# NAME:
# DESCRIPTION:
# WWW:

#ifd debian
[ -f /etc/defaults/exim4 ] && . /etc/defaults/exim4
#elsed gentoo
[ -f /etc/conf.d/exim ] && . /etc/conf.d/exim
#endd

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net daemon/exim/updateconf
		iset conflict = daemon/exim/combined
		iset provide = virtual/mta
		iset pid_file = "/var/run/exim4/exim.pid"
		iset exec daemon = "@/usr/sbin/exim4@ -bdf ${SMTPLISTENEROPTIONS} ${COMMONOPTIONS}"
	idone
}
