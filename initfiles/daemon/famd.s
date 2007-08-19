# SERVICE: daemon/famd
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister daemon
		iset need = system/bootmisc virtual/net/lo
		iset use = virtual/portmap
		iset exec daemon = "@/usr/sbin/famd@ -T 0 -f -c /etc/fam.conf"
	idone
}
