# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service #service/chvt/*
	iset need = system/bootmisc "virtual/getty/${NAME}"
	iset last
	iset exec start = "@chvt@ ${NAME}"
	idone
}
