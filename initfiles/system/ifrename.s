# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="system/ifrename"
	iregister service
	iset need = "system/initial system/mountfs/essential system/modules"
	iset require_file = /etc/iftab
	iset exec start = "@/sbin/ifrename@ -d -p"
	idone
}
