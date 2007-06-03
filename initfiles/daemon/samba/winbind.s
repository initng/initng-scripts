# SERVICE: daemon/samba/winbind
# NAME: samba
# DESCRIPTION: File and print server for Windows clients
# WWW: http://www.samba.org

setup()
{
	iregister daemon
		iset need = system/bootmisc
		iset respawn
		iset exec daemon = "@/usr/sbin/winbindd@ -F"
	idone
}
