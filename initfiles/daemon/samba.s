# NAME: samba
# DESCRIPTION: File and print server for Windows clients
# WWW: http://www.samba.org

setup()
{
	ireg daemon daemon/samba/winbind
	iset need = system/bootmisc
	iset respawn
	iset exec daemon = "@/usr/sbin/winbindd@ -F"
	idone

	ireg daemon daemon/samba/smbd
	iset need = system/bootmisc
	iset use = daemon/cupsd daemon/slapd
	iset respawn
	iset exec daemon = "@/usr/sbin/smbd@ -F"
	idone

	ireg daemon daemon/samba/nmbd
	iset need = system/bootmisc
	iset use = daemon/cupsd daemon/slapd
	iset respawn
	iset exec daemon = "@/usr/sbin/nmbd@ -F"
	idone

	ireg virtual daemon/samba
	iset also_stop = daemon/samba/{smbd,nmbd}
	iset need = daemon/samba/{smbd,nmbd}
	idone
}
