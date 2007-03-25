# NAME:
# DESCRIPTION:
# WWW:

UPEX4OPTS=""""
#ifd debian
source /etc/defaults/exim4
#elsed gentoo
source /etc/conf.d/exim
#endd

setup()
{
	iregister service

	iset need = "system/bootmisc"

	iexec start = "@update-exim4.conf@ ${UPEX4OPTS}"

	idone
}
