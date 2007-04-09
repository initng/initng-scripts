# NAME:
# DESCRIPTION:
# WWW:

#ifd debian
. /etc/defaults/exim4
#elsed gentoo
[ -f /etc/conf.d/exim ] && . /etc/conf.d/exim
#endd

setup()
{
	ireg service daemon/exim/updateconf
	iset need = system/bootmisc
	iset exec start = "@update-exim4.conf@ ${UPEX4OPTS}"
	idone
}
