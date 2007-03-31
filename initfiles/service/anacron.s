# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="service/anacron"
	iregister service
	iset need = "system/bootmisc"
	iset exec start = "@/usr/sbin/anacron@ -s"
	idone
}
