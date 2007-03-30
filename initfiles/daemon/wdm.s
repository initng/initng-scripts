# NAME: WDM
# DESCRIPTION: WINGs Display Manager
# WWW: http://voins.program.ru/wdm

setup()
{
	export SERVICE="daemon/wdm"
	iregister daemon
	iset need = "system/bootmisc"
	iset conflict = "daemon/gdm daemon/kdm daemon/xdm"
	iset provide = "virtual/dm"
	iset use = "system/modules system/coldplug"
	iset exec daemon = "@/usr/bin/wdm@ -nodaemon"
	idone
}
