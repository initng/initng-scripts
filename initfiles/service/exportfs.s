# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="service/exportfs"
	iregister service
	iset need = "system/mountfs"
	iset exec start = "@exportfs@ -ar"
	iset exec stop = "@exportfs@ -au"
	idone
}
