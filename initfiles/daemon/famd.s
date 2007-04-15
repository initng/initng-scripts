# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/famd && {
		iset need = system/bootmisc virtual/net/lo
		iset use = daemon/portmap
		iset exec daemon = "@/usr/sbin/famd@ -T 0 -f -c /etc/fam.conf"
	}
}
