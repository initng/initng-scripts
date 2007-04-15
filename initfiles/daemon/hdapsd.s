# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/hdapsd && {
		iset need = system/bootmisc virtual/net/lo system/modules
		iset exec daemon = "@/usr/sbin/hdapsd@ -a -d hda -s 18"
	}
}
