# SERVICE: system/swap
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial system/mountfs/essential
		iset start_fail_ok;
		iset exec start = "@/sbin/swapon@ -a"
		iset exec stop = "@/sbin/swapoff@ -a"
	idone
}
