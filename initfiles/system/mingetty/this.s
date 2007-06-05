# SERVICE: system/mingetty
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister virtual
		iset need = system/mingetty/tty2 system/mingetty/tty3 \
			    system/mingetty/tty4 system/mingetty/tty5 \
			    system/mingetty/tty6
		iset use = system/mountfs/essential service/issue
	idone
}
