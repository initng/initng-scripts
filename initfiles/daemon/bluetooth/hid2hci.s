# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service daemon/bluetooth/hid2hci && {
		iset need = system/bootmisc
		iset exec start = "@/usr/sbin/hid2hci@ -0"
		iset exec stop = "@/usr/sbin/hid2hci@ -1"
	}
}
