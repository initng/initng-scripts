# SERVICE: service/aumix
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset use = service/alsasound
		iset need = system/initial system/bootmisc
		iset stdall = "/dev/null"
		iset exec stop = "@/usr/bin/aumix@ -f /etc/aumixrc -S"
		iexec start
	idone
}

start()
{
	if [ -f /etc/aumixrc ]; then
		@/usr/bin/aumix@ -f /etc/aumixrc -L
	else
		@/usr/bin/aumix@ -v75 -c75 -w75
	fi
}
