# NAME: KDM
# DESCRIPTION: Graphical login manager for the K Desktop Environment (KDE)
# WWW: http://www.kde.org/

setup()
{
	ireg daemon daemon/kdm
	iset need = system/bootmisc
	iset conflict = daemon/gdm daemon/wdm daemon/xdm daemon/entranced
	iset use = daemon/xfs system/modules system/coldplug service/faketty
	iset provide = virtual/dm
	iset exec daemon = "@kdm@ -nodaemon"
	idone
}
