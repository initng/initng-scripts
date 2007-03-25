# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/initial system/bootmisc"

	iexec start = "@/etc/init.d/auditd@ start"
	iexec stop = "@/etc/init.d/auditd@ stop"

	idone
}

