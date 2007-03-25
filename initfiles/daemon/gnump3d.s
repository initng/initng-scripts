# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister -s "daemon/gnump3d/index" service
	iregister -s "daemon/gnump3d" daemon

	iset -s "daemon/gnump3d/index" need = "system/bootmisc"
	iset -s "daemon/gnump3d" need = "system/bootmisc virtual/net"
	iset -s "daemon/gnump3d" use = "daemon/gnump3d/index"
	iset -s "daemon/gnump3d" respawn

	iexec -s "daemon/gnump3d/index" start = "@/usr/bin/gnump3d-index@"
	iexec -s "daemon/gnump3d" daemon = "@/usr/bin/gnump3d@ --quiet"

	idone -s "daemon/gnump3d/index"
	idone -s "daemon/gnump3d"
}

