# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service system/swap && {
		iset need = system/initial system/mountfs/essential
		iset exec start = "@/sbin/swapon@ -a"
		iset exec stop = "@/sbin/swapoff@ -a"
	}
}
