# NAME: 
# DESCRIPTION: 
# WWW: 

setup()
{
	iregister service

	iset need = "system/bootmisc"

	iexec start = binfmt_start
	iexec stop = "@sysctl@ -n -w fs.binfmt_misc.status"

	idone
}

binfmt_start()
{
		@grep@ '^\s*#' /etc/binfmt | @grep@ '^\s*$' | while read line
		do
			@sysctl@ -n -w fs.binfmt_misc.register="${line}"
		done
}
