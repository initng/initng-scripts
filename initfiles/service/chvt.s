# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	# SERVICE: service/chvt/*
	iregister service
	iset need = "virtual/getty/${NAME} system/bootmisc"
	iset last
	iset exec start = "@chvt@ ${NAME}"
	idone
}
