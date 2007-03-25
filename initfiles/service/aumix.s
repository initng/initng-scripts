# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset use = "service/alsasound"
	iset need = "system/initial system/bootmisc"
	iset stdall = /dev/null

	iexec start = aumix_start
	iexec stop = "@/usr/bin/aumix@ -f /etc/aumixrc -S"

	idone
}

aumix_start()
{
		if [ -f /etc/aumixrc ]
		then
			@/usr/bin/aumix@ -f /etc/aumixrc -L
		else
			@/usr/bin/aumix@ -v75 -c75 -w75
		fi
}
