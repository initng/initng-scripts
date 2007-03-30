# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="system/swap"
	iregister service
	iset need = "system/initial system/mountfs/essential"
	iset exec start = "@/sbin/swapon@ -a"
	iset exec stop = "@/sbin/swapoff@ -a"
	idone
}
