# SERVICE: system/getty
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister virtual
		iset need = system/getty/2 system/getty/3 system/getty/4 \
			    system/getty/5 system/getty/6
		iset use = system/mountfs/essential service/issue
	idone
}
