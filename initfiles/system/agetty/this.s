# SERVICE: system/agetty
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister virtual
		iset need = system/agetty/tty2 system/agetty/tty3 \
		            system/agetty/tty4 system/agetty/tty5 \
		            system/agetty/tty6
		iset use = system/mountfs/essential service/issue
	idone
}
