# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg virtual daemon/nut
	iset also_stop = daemon/nut/{upsdrv,upsd,upsmon}
	iset need = system/bootmisc daemon/nut/{upsdrv,upsd}
	iset use = daemon/nut/upsmon
	idone
}
