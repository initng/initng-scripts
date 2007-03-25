# NAME: WDM
# DESCRIPTION: WINGs Display Manager
# WWW: http://voins.program.ru/wdm

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset conflict = "daemon/gdm daemon/kdm daemon/xdm"
	iset provide = "virtual/dm"
	iset use = "system/modules system/coldplug"

	iexec daemon = "@/usr/bin/wdm@ -nodaemon"

	idone
}

