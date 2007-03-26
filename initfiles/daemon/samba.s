# NAME: samba
# DESCRIPTION: File and print server for Windows clients
# WWW: http://www.samba.org

setup()
{
	iregister -s "daemon/samba/winbind" daemon
	iregister -s "daemon/samba/smbd" daemon
	iregister -s "daemon/samba/nmbd" daemon
	iregister -s "daemon/samba" virtual

	iset -s "daemon/samba/winbind" need = "system/bootmisc"
	iset -s "daemon/samba/winbind" respawn
	iset -s "daemon/samba/smbd" need = "system/bootmisc"
	iset -s "daemon/samba/smbd" use = "daemon/cupsd daemon/slapd"
	iset -s "daemon/samba/smbd" respawn
	iset -s "daemon/samba/nmbd" need = "system/bootmisc"
	iset -s "daemon/samba/nmbd" use = "daemon/cupsd daemon/slapd"
	iset -s "daemon/samba/nmbd" respawn
	iset -s "daemon/samba" also_stop = "daemon/samba/smbd daemon/samba/nmbd"
	iset -s "daemon/samba" need = "daemon/samba/smbd daemon/samba/nmbd"

	iexec -s "daemon/samba/winbind" daemon = "@/usr/sbin/winbindd@ -F"
	iexec -s "daemon/samba/smbd" daemon = "@/usr/sbin/smbd@ -F"
	iexec -s "daemon/samba/nmbd" daemon = "@/usr/sbin/nmbd@ -F"

	idone -s "daemon/samba/winbind"
	idone -s "daemon/samba/smbd"
	idone -s "daemon/samba/nmbd"
	idone -s "daemon/samba"
}
