# SERVICE: daemon/bluetooth/hciattach/*
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/bootmisc daemon/bluetooth/hcid
		iset exec start = "@/usr/sbin/hciattach@ ${NAME}"
	idone
}
