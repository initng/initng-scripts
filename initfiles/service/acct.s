# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service service/acct && {
		iset need = system/initial system/mountfs/essential
		iset exec stop = "@/usr/sbin/accton@"
		iexec start
	}
}

start()
{
	@touch@ /var/account/pacct
	@chmod@ 600 /var/account/pacct
	@/usr/sbin/accton@ /var/account/pacct
}
