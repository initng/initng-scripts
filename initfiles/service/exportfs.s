# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service service/exportfs
	iset need = system/mountfs
	iset exec start = "@exportfs@ -ar"
	iset exec stop = "@exportfs@ -au"
	idone
}
