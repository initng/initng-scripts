# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	export SERVICE="system/rmnologin"
	iregister service
	iset need = "system/mountfs/essential"
	iexec start
	idone
}

start()
{
	[ -f /etc/nologin.boot ] &&
		@rm@ -f /etc/nologin /etc/nologin.boot >/dev/null 2>&1
}
