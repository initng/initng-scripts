# SERVICE: service/chvt/*
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/bootmisc "virtual/getty/${NAME}"
		iset last
		iset exec start = "@chvt@ ${NAME}"
	idone
}
