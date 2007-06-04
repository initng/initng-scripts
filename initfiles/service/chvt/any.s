# SERVICE: service/chvt/*
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister task
		iset need = system/bootmisc "virtual/getty/${NAME}"
		iset once
		iset last
		iset exec task = "@chvt@ ${NAME}"
	idone
}
