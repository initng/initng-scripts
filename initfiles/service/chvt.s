# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	[ "${SERVICE}" = service/chvt ] && return 1

	# service/chvt/*
	ireg service && {
		iset need = system/bootmisc "virtual/getty/${NAME}"
		iset last
		iset exec start = "@chvt@ ${NAME}"
	}
}
