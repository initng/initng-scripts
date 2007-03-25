# NAME: ESounD
# DESCRIPTION: The Enlightened Sound Daemon
# WWW: http://www.tux.org/~ricdude/EsounD.html

setup()
{
	iregister daemon

	iset need = "system/bootmisc service/alsasound"

	iexec daemon = "@/usr/bin/esd@ -nobeeps -as 2 -tcp -public"

	idone
}

