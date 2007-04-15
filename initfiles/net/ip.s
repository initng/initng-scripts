# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	[ "${SERVICE}" = net/ip ] && return 1

	ireg service && {
		iset need = "system/bootmisc"
		iset use = "net/bridge/${NAME} net/iwconfig/${NAME}"
		iset provide = "virtual/net virtual/net/${NAME}"
		iexec start
		iexec stop
	}
}

start()
{
	@ip@ addr add ${config_$NAME} ${NAME}
	@ip@ link set ${NAME} up
}

stop()
{
	@ip@ link set ${NAME} down
	@ip@ addr del ${config_$NAME} ${NAME}
}
