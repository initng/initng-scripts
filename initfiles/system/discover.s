# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="system/discover"
	iregister service
	iset need = "system/initial system/mountroot system/modules"
	iset exec start = "@discover-modprobe@ -v"
	idone
}
