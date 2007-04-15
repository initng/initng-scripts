# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	[ "${SERVICE}" = daemon/bluetooth/hciattach ] && exit 1

	# daemon/bluetooth/hciattach/*
	ireg service && {
		iset need = system/bootmisc daemon/bluetooth/hcid
		iset exec start = "@/usr/sbin/hciattach@ ${NAME}"
	}
}
