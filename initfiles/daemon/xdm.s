# NAME: Xdm
# DESCRIPTION: X.org graphical greeter
# WWW: http://xorg.freedesktop.org

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset conflict = "daemon/gdm daemon/kdm daemon/wdm"
	iset use = "system/modules system/coldplug service/faketty"
	iset provide = "virtual/dm"

#ifd debian
	iexec daemon = "@/usr/bin/X11/xdm@ -nodaemon"
#elsed
	iexec daemon = "@/usr/sbin/xdm:/usr/bin/xdm@ -nodaemon"
#endd

	idone
}

