# SERVICE: service/printconf
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/bootmisc
		iset exec start = "@/usr/sbin/printconf-backend@"
	idone
}
