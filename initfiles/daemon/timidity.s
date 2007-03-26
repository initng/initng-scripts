# NAME: timidity++
# DESCRIPTION: Software MIDI synthesiser
# WWW: http://timidity.sourceforge.net

#ifd gentoo
source /etc/conf.d/timidity
#endd

setup()
{
	iregister daemon

	iset need = "service/alsasound system/bootmisc"
#ifd gentoo
	iset use = "daemon/esound"
#endd

#ifd gentoo
	iset exec daemon = "@/usr/bin/timidity@ -iA ${TIMIDITY_OPTS}"
#elsed
	iset exec daemon = "@/usr/bin/timidity@ -iA -B2,8 -Os"
#endd

	idone
}

