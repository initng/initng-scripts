# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service system/serial
	iset need = system/initial system/mountroot system/modules/serial
	iexec start
	idone
}

start()
{
	[ -e /etc/serial.conf ] || exit 0

	@grep@ -v "^#\|^ \|^$" /etc/serial.conf | while read device args
	do
		@/bin/setserial@ -b ${device} ${args} 1>&2 &
	done
	wait
}
