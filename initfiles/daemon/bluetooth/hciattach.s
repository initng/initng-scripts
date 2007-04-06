# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	is_service daemon/bluetooth/hciattach && exit 0

	ireg service #daemon/bluetooth/hciattach/*
	iset need = system/bootmisc daemon/bluetooth/hcid
	iset exec start = "@/usr/sbin/hciattach@ ${NAME}"
	idone
}
