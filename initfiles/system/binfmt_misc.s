# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	ireg service system/binfmt_misc && {
		iset need = system/bootmisc
		iset exec stop = "@sysctl@ -n -w fs.binfmt_misc.status"
		iexec start
	}
}

start()
{
	@grep@ '^\s*#' /etc/binfmt | @grep@ '^\s*$' | while read line
	do
		@sysctl@ -n -w fs.binfmt_misc.register="${line}"
	done
}
