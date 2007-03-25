# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service

	iset need = "system/mountfs/essential"

	iexec start = rmnologin_start

	idone
}

rmnologin_start()
{
		if [ -f /etc/nologin.boot ]
		then
			@rm@ -f /etc/nologin /etc/nologin.boot >/dev/null 2>&1
		fi
}
