# SERVICE: daemon/gdm
# NAME: GDM
# DESCRIPTION: Graphical login manager for the GNOME desktop environment
# WWW: http://www.gnome.org/projects/gdm/

#ifd debian
[ -f /etc/default/gdm ] && . /etc/default/gdm
#endd

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset use = daemon/xfs service/faketty service/xorgconf
#ifd pingwinek
		iset use = system/dbus
#elsed
		iset use = daemon/915resolution
#endd
		iset conflict = daemon/kdm daemon/wdm daemon/xdm \
		                daemon/entranced daemon/slim
		iset provide = virtual/dm
		iset exec daemon = "@/usr/sbin/gdm@ -nodaemon"
	idone
}
