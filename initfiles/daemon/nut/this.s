# SERVICE: daemon/nut
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister virtual
		iset also_stop = daemon/nut/upsdrv daemon/nut/upsd \
				 daemon/nut/upsmon
		iset need = system/bootmisc daemon/nut/upsdrv daemon/nut/upsd
		iset use = daemon/nut/upsmon
	idone
}
