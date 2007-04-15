# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	[ "${SERVICE}" = net/iwconfig ] && return 1

	ireg service && {
		iset need = "bootmisc"
		iexec start = iwconfig_any_start
	}
}

iwconfig_any_start()
{
	essid=${essid_$NAME}
	@iwconfig@ essid ${NAME} ${essid}
	@iwconfig@ key ${NAME} ${key_$essid}
	@iwconfig@ chan ${NAME} ${channel_$essid}
}
