# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service daemon/gnump3d/index
	iset need = system/bootmisc
	iset exec start = "@/usr/bin/gnump3d-index@"
	idone

	ireg daemon daemon/gnump3d
	iset need = system/bootmisc virtual/net
	iset use = daemon/gnump3d/index
	iset respawn
	iset exec daemon = "@/usr/bin/gnump3d@ --quiet"
	idone
}
