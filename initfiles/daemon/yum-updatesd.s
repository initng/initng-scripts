# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/yum-updatesd
	iset need = system/bootmisc virtual/net daemon/dbus
	iset exec daemon = "@/usr/sbin/yum-updatesd@ -f"
	idone
}
