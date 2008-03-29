# SERVICE; daemon/gnump3d/index
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/bootmisc
		iset exec start = "@/usr/bin/gnump3d-index@"
	idone
}
