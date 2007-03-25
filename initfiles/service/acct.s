# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/initial system/mountfs/essential"

	iexec start = acct_start
	iexec stop = "@/usr/sbin/accton@"

	idone
}

acct_start()
{
		@touch@ /var/account/pacct
		@chmod@ 600 /var/account/pacct
		@/usr/sbin/accton@ /var/account/pacct
}
