# SERVICE: daemon/wdm
# NAME: WDM
# DESCRIPTION: WINGs Display Manager
# WWW: http://voins.program.ru/wdm

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset conflict = daemon/gdm daemon/kdm daemon/xdm \
		                daemon/entranced daemon/slim
		iset provide = virtual/dm
		iset use = system/modules system/coldplug
		iset exec daemon = "@/usr/bin/wdm@ -nodaemon"
	idone
}
