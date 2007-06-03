# SERVICE: daemon/exim/updateconf
# NAME:
# DESCRIPTION:
# WWW:

#ifd debian
[ -f /etc/defaults/exim4 ] && . /etc/defaults/exim4
#elsed gentoo
[ -f /etc/conf.d/exim ] && . /etc/conf.d/exim
#endd

setup()
{
	iregister service
		iset need = system/bootmisc
		iset exec start = "@update-exim4.conf@ ${UPEX4OPTS}"
	idone
}
