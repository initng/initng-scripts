# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/bootmisc"
	iset use = "net/bridge/${NAME} net/iwconfig/${NAME}"
	iset provide = "virtual/net virtual/net/${NAME}"

	iexec start = ip_any_start
	iexec stop = ip_any_stop

	idone
}

ip_any_start()
{
		@ip@ addr add ${config_$NAME} ${NAME}
		@ip@ link set ${NAME} up
}

ip_any_stop()
{
		@ip@ link set ${NAME} down
		@ip@ addr del ${config_$NAME} ${NAME}
	}
}
