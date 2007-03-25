# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon

	iset need = "system/bootmisc virtual/net/lo system/modules"

	iexec daemon = "@/usr/sbin/hdapsd@ -a -d hda -s 18"

	idone
}

