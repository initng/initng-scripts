# NAME: CUPS
# DESCRIPTION: The Common Unix Printing System
# WWW: http://www.cups.org

setup()
{
	ireg daemon daemon/cupsd && {
		iset need = system/bootmisc virtual/net/lo
		iset use = daemon/printconf daemon/hpiod daemon/hpssd
		iset exec daemon = "@/usr/sbin/cupsd@ -F"
	}
}
