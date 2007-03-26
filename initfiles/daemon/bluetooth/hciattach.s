# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister -s "daemon/bluetooth/hciattach/*" service

	iset -s "daemon/bluetooth/hciattach/*" need = "system/bootmisc daemon/bluetooth/hcid"

	iset -s "daemon/bluetooth/hciattach/*" exec start = "@/usr/sbin/hciattach@ ${NAME}"

	idone
}
