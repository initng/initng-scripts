# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service system/ifrename && {
		iset need = system/initial system/mountfs/essential system/modules
		iset require_file = /etc/iftab
		iset exec start = "@/sbin/ifrename@ -d -p"
	}
}
