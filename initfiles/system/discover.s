# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/initial system/mountroot system/modules"

	iexec start = "@discover-modprobe@ -v"

	idone
}

