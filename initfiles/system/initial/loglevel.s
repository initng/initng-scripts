# SERVICE: system/initial/loglevel
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset exec start = "@/sbin/dmesg@ -n 1"
		iset exec stop = "@/sbin/dmesg@ -n 2"
	idone
}
