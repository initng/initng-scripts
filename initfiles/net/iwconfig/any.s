# SERVICE: net/iwconfig/*
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = "bootmisc"
		iexec start
	idone
}

start()
{
	eval essid=\${essid_$NAME}
	@iwconfig@ essid ${NAME} ${essid}
	eval @iwconfig@ key ${NAME} \${key_$essid}
	eval @iwconfig@ chan ${NAME} \${channel_$essid}
}
