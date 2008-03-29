# SERVICE: daemon/samba/smbd
# NAME: samba
# DESCRIPTION: File and print server for Windows clients
# WWW: http://www.samba.org

setup() {
	iregister daemon
		iset need = system/bootmisc
		iset use = daemon/cupsd daemon/slapd
		iset respawn
		iset exec daemon = "@/usr/sbin/smbd@ -F"
	idone
}
