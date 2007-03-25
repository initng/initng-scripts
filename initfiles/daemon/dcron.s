# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister daemon

	iset need = "system/bootmisc"
	iset provide = "virtual/cron"

	iexec daemon = "@/usr/sbin/crond@ -n"

	idone
}

