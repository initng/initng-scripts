# NAME: SLIM 
# DESCRIPTION: The "slim" desktop-independent login manager. 
# WWW: http://slim.berlios.de/  

setup()
{
	ireg daemon daemon/slim
	iset need = system/bootmisc
	iset conflict = daemon/kdm daemon/wdm daemon/xdm daemon/entraced daemon/gdm
	iset provide = virtual/dm;
	iset exec daemon = "/usr/bin/slim"
	idone  
}
