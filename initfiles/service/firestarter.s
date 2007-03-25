# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/initial system/mountroot virtual/net/lo"
	iset provide = "virtual/firewall"

	iexec start = "@/etc/firestarter/firestarter.sh@ start"
	iexec stop = "@/etc/firestarter/firestarter.sh@ stop"

	idone
}

