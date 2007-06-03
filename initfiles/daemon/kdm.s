# SERVICE: daemon/kdm
# NAME: KDM
# DESCRIPTION: Graphical login manager for the K Desktop Environment (KDE)
# WWW: http://www.kde.org/

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset conflict = daemon/gdm daemon/wdm daemon/xdm \
		                daemon/entranced daemon/slim
		iset use = daemon/xfs system/modules system/coldplug \
		           service/faketty
		iset provide = virtual/dm
		iset exec daemon = "@kdm@ -nodaemon"
	idone
}
