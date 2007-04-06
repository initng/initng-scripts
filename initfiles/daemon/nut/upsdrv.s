# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service daemon/nut/upsdrv
	iset need = system/bootmisc system/modules
	iset exec start = "@/usr/sbin/upsdrvctl@ start"
	iset exec stop = "@/usr/sbin/upsdrvctl@ stop"
	idone
}
