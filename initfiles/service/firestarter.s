# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/initial system/mountroot virtual/net/lo"
	iset provide = "virtual/firewall"
	iset exec start = "@/etc/firestarter/firestarter.sh@ start"
	iset exec stop = "@/etc/firestarter/firestarter.sh@ stop"

	idone
}
