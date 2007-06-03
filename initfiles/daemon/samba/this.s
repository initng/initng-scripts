# SERVICE: daemon/samba
# NAME: samba
# DESCRIPTION: File and print server for Windows clients
# WWW: http://www.samba.org

setup()
{
	iregister virtual
		iset also_stop = daemon/samba/smbd daemon/samba/nmbd
		iset need = daemon/samba/smbd daemon/samba/nmbd
	idone
}
