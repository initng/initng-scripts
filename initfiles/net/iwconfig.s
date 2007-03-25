# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "bootmisc"

	iexec start = iwconfig_any_start

	idone
}

iwconfig_any_start()
{
		essid=${essid_$NAME}
		@iwconfig@ essid ${NAME} ${essid}
		@iwconfig@ key ${NAME} ${key_$essid}
		@iwconfig@ chan ${NAME} ${channel_$essid}
}
