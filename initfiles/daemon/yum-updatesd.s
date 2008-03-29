# SERVICE: daemon/yum-updatesd
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister daemon
		iset need = system/bootmisc virtual/net daemon/dbus
		iset exec daemon = "@/usr/sbin/yum-updatesd@ -f"
	idone
}
