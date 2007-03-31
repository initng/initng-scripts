# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="service/acct"
	iregister service
	iset need = "system/initial system/mountfs/essential"
	iset exec stop = "@/usr/sbin/accton@"
	iexec start
	idone
}

start()
{
	@touch@ /var/account/pacct
	@chmod@ 600 /var/account/pacct
	@/usr/sbin/accton@ /var/account/pacct
}
