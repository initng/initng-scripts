# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/initial system/mountfs/essential"

	iexec start = "@/sbin/swapon@ -a"
	iexec stop = "@/sbin/swapoff@ -a"

	idone
}

