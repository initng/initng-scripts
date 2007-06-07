# SERVICE: system/mountfs/home
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/mountroot system/checkfs
		iset never_kill
		iexec start
	idone
}

start()
{
	@grep@ -q "[[:space:]]/home[[:space:]]" /etc/fstab &&
		@mount@ -v /home
	exit 0
}
