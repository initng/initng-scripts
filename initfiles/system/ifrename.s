# SERVICE: system/ifrename
# NAME:
# DESCRIPTION:
# WWW:

setup() {
	iregister service
		iset need = system/initial system/mountfs/essential system/modules
		iset require_file = /etc/iftab
		iset exec start = "@/sbin/ifrename@ -d -p"
	idone
}
