# SERVICE: system/qingy
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister virtual
		iset need = system/qingy/tty2 system/qingy/tty3 \
		            system/qingy/tty4 system/qingy/tty5 \
		            system/qingy/tty6
		iset use = system/mountfs/essential service/issue
	idone
}
