# SERVICE: daemon/xdm
# NAME: Xdm
# DESCRIPTION: X.org graphical greeter
# WWW: http://xorg.freedesktop.org

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset conflict = daemon/gdm daemon/kdm daemon/wdm \
		                daemon/entranced daemon/slim
		iset use = system/modules system/coldplug service/faketty
		iset provide = virtual/dm
#ifd debian
		iset exec daemon = "@/usr/bin/X11/xdm@ -nodaemon"
#elsed
		iset exec daemon = "@/usr/sbin/xdm:/usr/bin/xdm@ -nodaemon"
#endd
	idone
}
