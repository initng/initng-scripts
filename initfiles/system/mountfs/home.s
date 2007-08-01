# SERVICE: system/mountfs/home
# NAME:
# DESCRIPTION:
# WWW:

setup()
{
	iregister service
		iset need = system/mountroot system/checkfs
		iset stderr = /dev/null
		iset start_fail_ok
		iset never_kill
		iset exec start = "@mount@ -v /home"
	idone
}
