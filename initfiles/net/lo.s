# SERVICE: net/*
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset stdall = "/dev/null"
		iset need = system/bootmisc
		iset provide = "virtual/net/lo"
		iset exec start = "@/sbin/ifconfig@ lo up"
		iset exec stop = "@/sbin/ifconfig@ lo down"
	idone
}
