# NAME: GDM
# DESCRIPTION: Graphical login manager for the GNOME desktop environment
# WWW: http://www.gnome.org/projects/gdm/

#ifd debian
source /etc/default/gdm
#endd

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset use = "daemon/xfs service/faketty service/xorgconf"
#ifd pingwinek
	iset use = "system/dbus"
#elsed
	iset use = "daemon/915resolution"
#endd
	iset conflict = "daemon/kdm daemon/wdm daemon/xdm daemon/entranced"
	iset provide = "virtual/dm"

#ifd debian
	iexec daemon = "@gdm@ -nodaemon"
#elsed
	iexec daemon = "@/usr/sbin/gdm@ -nodaemon"
#endd

	idone
}
