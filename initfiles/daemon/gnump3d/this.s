# SERVICE: daemon/gnump3d
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc virtual/net
		iset use = daemon/gnump3d/index
		iset respawn
		iset exec daemon = "@/usr/bin/gnump3d@ --quiet"
	idone
}
