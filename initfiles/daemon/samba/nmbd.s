# SERVICE: daemon/samba/nmbd
# NAME: samba
# DESCRIPTION: File and print server for Windows clients
# WWW: http://www.samba.org

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset use = daemon/cupsd daemon/slapd
		iset respawn
		iset exec daemon = "@/usr/sbin/nmbd@ -F"
	idone
}
