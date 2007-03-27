# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
	iset      need = "system/initial system/mountroot system/modules"
	iset      exec start = "@discover-modprobe@ -v"
	idone
}
