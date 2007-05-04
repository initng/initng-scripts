# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg virtual daemon/nut && {
		iset also_stop = daemon/nut/upsdrv daemon/nut/upsd \
				 daemon/nut/upsmon
		iset need = system/bootmisc daemon/nut/upsdrv daemon/nut/upsd
		iset use = daemon/nut/upsmon
	}
}
