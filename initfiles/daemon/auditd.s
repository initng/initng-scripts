# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service daemon/auditd && {
		iset need = system/initial system/bootmisc
		iset exec start = "@/etc/init.d/auditd@ start"
		iset exec stop = "@/etc/init.d/auditd@ stop"
	}
}
