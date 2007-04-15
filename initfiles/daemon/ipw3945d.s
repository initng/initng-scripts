# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg daemon daemon/ipw3945d && {
		iset need = system/bootmisc system/mountfs/essential \
		            system/modules/ipw3945
		iset exec daemon = "@/sbin/ipw3945d@ --foreground --timeout"
	}
}
