# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net daemon/dbus"

	iexec daemon = "@/usr/sbin/yum-updatesd@ -f"

	idone
}

