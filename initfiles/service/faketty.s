# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="service/faketty"
	iregister service
	iset need = "system/initial"
	iexec start
	idone
}

start()
{
	@rm@ -f /dev/tty5[0-9]
	@/sbin/modprobe@ faketty
	for tmp in 0 1 2 3 4 5 6 7 8 9
	do
		@ln@ -s /dev/ftty${tmp} /dev/tty5${tmp}
	done
}
