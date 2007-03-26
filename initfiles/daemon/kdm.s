# NAME: KDM
# DESCRIPTION: Graphical login manager for the K Desktop Environment (KDE)
# WWW: http://www.kde.org/

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset conflict = "daemon/gdm daemon/wdm daemon/xdm"
	iset use = "daemon/xfs system/modules system/coldplug service/faketty"
	iset provide = "virtual/dm"

#ifd debian
	iset exec daemon = "@/usr/bin/kdm@ -nodaemon"
#elsed
	iset exec daemon = "@/usr/sbin/kdm:/usr/bin/kdm@ -nodaemon"
#endd

	idone
}

