# SERVICE: system/fgetty
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg virtual
		iset need = system/fgetty/tty2 system/fgetty/tty3 \
		            system/fgetty/tty4 system/fgetty/tty5 \
		            system/fgetty/tty6
		iset use = system/mountfs/essential service/issue
	idone
}
