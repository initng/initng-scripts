# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "virtual/getty/${NAME} system/bootmisc"
	iset last

	iexec start = "@chvt@ ${NAME}"

	idone
}

