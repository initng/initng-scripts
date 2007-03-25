# NAME: powernowd
# DESCRIPTION: CPU clock/voltage adjustment daemon
# WWW: http://www.deater.net/john/powernowd.html

#ifd debian
OPTIONS =" -q -m 2"
source /etc/default/powernowd
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset use = "service/speedstep"

#ifd debian
	iexec daemon = "@/usr/sbin/powernowd@ ${OPTIONS}"
#elsed
	iexec daemon = "@/usr/sbin/powernowd@ -q"
#endd

	idone
}

