# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/mountfs"

	iexec start = "@exportfs@ -ar"
	iexec stop = "@exportfs@ -au"

	idone
}

