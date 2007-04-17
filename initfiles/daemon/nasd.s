# NAME: Network Audio System
# DESCRIPTION:
# WWW:

setup() {
	ireg daemon daemon/nasd && {
		iset need = system/initial system/bootmisc system/mountfs
		iset use = system/alsasound
		iset respawn
		iset exec daemon = "@/usr/bin/nasd@"
	}
}
