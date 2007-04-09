# NAME: timidity++
# DESCRIPTION: Software MIDI synthesiser
# WWW: http://timidity.sourceforge.net

#ifd gentoo
. /etc/conf.d/timidity
#elsed
TIMIDITY_OPTS="-B2,8 -Os"
#endd

setup()
{
	ireg daemon daemon/timidity
	iset need = service/alsasound system/bootmisc
#ifd gentoo
	iset use = daemon/esound
#endd
	iexec daemon
	idone
}

daemon()
{
	exec @/usr/bin/timidity@ -iA ${TIMIDITY_OPTS}
}
