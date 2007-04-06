# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service system/discover
	iset need = system/initial system/mountroot system/modules
	iset exec start = "@discover-modprobe@ -v"
	idone
}
