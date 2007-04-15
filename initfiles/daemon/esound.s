# NAME: ESounD
# DESCRIPTION: The Enlightened Sound Daemon
# WWW: http://www.tux.org/~ricdude/EsounD.html

setup()
{
	ireg daemon daemon/esound && {
		iset need = system/bootmisc service/alsasound
		iset exec daemon = "@/usr/bin/esd@ -nobeeps -as 2 -tcp -public"
	}
}
