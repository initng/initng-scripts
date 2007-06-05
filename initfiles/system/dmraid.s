# SERVICE: system/dmraid
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset use = system/modules system/udev
		iset exec start = "@/sbin/dmraid@ --activate yes --ignorelocking"
		iset exec stop = "@/sbin/dmraid@ --activate no --ignorelocking"
	idone
}
